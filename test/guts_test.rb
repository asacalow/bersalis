require File.join(File.dirname(__FILE__), 'test_helper')

class ConnectionTest < Test::Unit::TestCase
  context 'Connection' do
    setup do
      @klass = mock('client class')
      @client = mock('client', {:start => nil})
      @klass.stubs(:new).returns(@client)
    end

    context 'initialising' do
      should 'instantiate a client' do
        @klass.expects(:new).returns(@client)
        Bersalis::Connection.new('dummysig', @klass)
      end
    end

    context 'starting' do
      should 'instantiate a parser' do
        Nokogiri::XML::SAX::PushParser.expects(:new)
        connection = Bersalis::Connection.new('dummysig', @klass)
        connection.start
      end
    end
    
    context 'receiving data' do
      setup do
        @parser = mock('Parser')
        @connection = Bersalis::Connection.new('dummysig', @klass)
        @connection.parser = @parser
        @parser.stubs('<<')
      end
      
      should 'hand it off to the parser' do
        data = '<foo />'
        @parser.expects('<<').with(data)
        @connection.receive_data(data)
      end
      
      should 'log the incoming data' do
        Bersalis.expects(:debug)
        @connection.receive_data('foo')
      end
    end
  end
end

class ClientTest < Test::Unit::TestCase
  context 'Client' do
    setup do
      @connection = mock('Connection')
    end

    context 'starting' do
      setup do
        @connection.stubs(:start)
        @connection.stubs(:send_data)
        @client = Bersalis::Client.new(@connection)
      end

      should 'set up the connection' do
        @connection.expects(:start)
        @client.start
      end

      should 'send a stream start message' do
        @connection.expects(:send_data).with(Bersalis::Client::START_STREAM)
        @client.start
      end
    end

    should 'restarting should start again' do
      client = Bersalis::Client.new(@connection)
      client.expects(:start)
      client.restart
    end

    context 'creating a handler' do
      should 'add a handler' do
        klass = 'Foo'
        method = 'bar'
        options = {}
        Bersalis::Client::HANDLERS.expects(:<<)
        Bersalis::Client.handle(klass,method,options)
      end
    end

    context 'process' do
      should 'not do anything with an unrecognised stanza' do
        node = mock('node')
        client = Bersalis::Client.new(@connection)
        client.stubs(:stanza_class_for).returns(nil)
        client.expects(:handler_for).never
        client.process(node)
      end

      should 'apply the handler for a recognised stanza' do
        node = mock('node')
        klass = mock('Stanza class')
        stanza = mock('Stanza')
        klass.stubs(:new).returns(stanza)
        
        client = Bersalis::Client.new(@connection)
        client.stubs(:stanza_class_for).with(node).returns(klass)
        
        handler = {:method => :handlethis}
        client.stubs(:handler_for).with(klass, node).returns(handler)
        
        client.expects(:send).with(:handlethis, stanza)
        
        client.process(node)
      end
    end

    context 'write data' do
      setup do
        @connection.stubs(:send_data)
      end
      
      should 'convert the stanza to xml' do
        stanza = mock('Stanza')
        stanza.expects(:to_xml)
        client = Bersalis::Client.new(@connection)
        client.write(stanza)
      end
      
      should 'send data over the connection' do
        stanza = mock('Stanza')
        data = '<bar />'
        stanza.expects(:to_xml).returns(data)
        @connection.expects(:send_data).with(data)
        client = Bersalis::Client.new(@connection)
        client.write(stanza)
      end
    end
    
    context 'stanza_class_for' do
      setup do
        @klass = mock('Stanza class')
        @opts = {
          :path => '/a/test/foo:path', 
          :namespaces => {:foo => 'http://foo.com'}
        }
        Bersalis::KNOWN_STANZAS[@klass] = @opts
        @node = mock('Node')
        @node.stubs(:at)
      end
      
      should 'return a stanza class if node is recognised' do
        @node.expects(:at).with(@opts[:path], @opts[:namespaces]).returns(true)
        client = Bersalis::Client.new(@connection)
        assert_equal client.send(:stanza_class_for, @node), @klass
      end
      
      should 'return nothing if the node is unrecognised' do
        @node.expects(:at).with(@opts[:path], @opts[:namespaces]).returns(nil)
        client = Bersalis::Client.new(@connection)
        assert_equal client.send(:stanza_class_for, @node), nil
      end
    end
    
    context 'handler_for' do
      setup do
        @klass = mock('Stanza class')
        @node=  mock('Node')
        @opts = {:iama => 'handler'}
      end
      
      should 'return a handler when recognised' do
        Bersalis::Client::HANDLERS.expects(:select).returns([@opts])
        client = Bersalis::Client.new(@connection)
        assert_equal client.send(:handler_for, @klass, @node), @opts
      end
      
      should 'not return a recognised handler where a filter has been applied' do
        @opts[:filter] = '/nothing/to/see/here'
        @node.expects(:at).with(@opts[:filter], {}).returns(nil)
        Bersalis::Client::HANDLERS.expects(:select).returns([@opts])
        client = Bersalis::Client.new(@connection)
        assert_equal client.send(:handler_for, @klass, @node), nil
      end
    end
  end
end

class DocumentTest < Test::Unit::TestCase
  context 'Document' do
    setup do
      @client = mock('Client')
      @parser = Nokogiri::XML::SAX::PushParser.new(Bersalis::Document.new(@client))
    end
  
    should 'process a complete stanza' do
      @client.expects(:process)
      @parser << "<foo bar=\"foobar\"><baz /></foo>"
    end
  
    should 'not process an incomplete stanza' do
      @client.expects(:process).never
      @parser << "<foo bar=\"foobar\"><baz />"
    end
    
    should 'create a node from the parser input' do
      class << @client
        attr_accessor :node
        
        def process(node)
          self.node = node
        end
      end
      
      @parser << "<foo bar=\"foobar\"><baz /></foo>"
      
      assert_kind_of Bersalis::Node, @client.node
      assert_equal @client.node.name, 'foo'
    end
  end
end