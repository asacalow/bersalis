require File.join(File.dirname(__FILE__), '..', 'test_helper')

class ClientTest < Test::Unit::TestCase
  context 'Client' do
    context 'starting' do
      setup do
        @connection = mock('Connection')
        @connection.stubs(:start)
        @client = Bersalis::Client.new
        @client.connection = @connection
        @client.stubs(:write)
      end

      should 'start the connection' do
        @connection.expects(:start)
        @client.start
      end

      should 'send a stream start message' do
        @client.expects(:write).with(Bersalis::Client::START_STREAM)
        @client.start
      end
    end
    
    context 'restarting' do
      should 'just call start again' do
        client = Bersalis::Client.new
        client.expects(:start)
        client.restart
      end
    end
    
    context 'starting tls' do
      should 'start tls on the connection' do
        connection = mock('Connection')
        client = Bersalis::Client.new
        client.connection = connection
        
        connection.expects(:start_tls)
        client.start_tls
      end
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
      setup do
        @node = mock('Node')
        @stanza_klass = mock('Stanza class')
        @stanza = mock('Stanza')
        @stanza_klass.stubs(:new).returns(@stanza)
        @client = Bersalis::Client.new
        @client.stubs(:callback_for).returns(nil)
      end
      
      should 'stop processing if a callback is found' do
        @client.stubs(:callback_for).returns('something')
        @client.expects(:stanza_classes_for).never
        @client.process(@node)
      end
      
      should 'not look for a handler for an unrecognised stanza' do
        @client.stubs(:stanza_classes_for).returns([])
        @client.expects(:handler_for).never
        assert_nil @client.process(@node)
      end

      should 'apply the handler for a recognised stanza' do
        @client.stubs(:stanza_classes_for).with(@node).returns([@stanza_klass])
        handler = {:method => :handlethis}
        @client.stubs(:handler_for).with(@stanza_klass, @node).returns(handler)
        @client.expects(:send).with(:handlethis, @stanza)
        @client.process(@node)
      end
      
      should 'apply the correct handler when the stanza is recognised as a couple of different things' do
        another_klass = mock('Stanza class')
        another_stanza = mock('Stanza')
        another_klass.stubs(:new).returns(another_stanza)
        @client.stubs(:stanza_classes_for).with(@node).returns([another_klass, @stanza_klass])
        handler = {:method => :handlethis}
        @client.stubs(:handler_for).with(another_klass, @node).returns(nil)
        @client.stubs(:handler_for).with(@stanza_klass, @node).returns(handler)
        @client.expects(:send).with(:handlethis, @stanza)
        @client.expects(:send).with(:handlethis, another_stanza).never
        @client.process(@node)
      end
    end

    context 'write' do
      setup do
        @connection = mock('Connection')
        @connection.stubs(:send_data)
      end
      
      should 'convert the stanza to xml if appropriate' do
        stanza = mock('Stanza')
        stanza.stubs(:respond_to?).with(:to_xml).returns(true)
        stanza.expects(:to_xml)
        client = Bersalis::Client.new
        client.connection = @connection
        client.write(stanza)
      end
      
      should 'just send the stanza without converting it if appropriate' do
        xml = '<foo />'
        client = Bersalis::Client.new
        client.connection = @connection
        @connection.expects(:send_data).with(xml)
        client.write(xml)
      end
      
      should 'send data over the connection' do
        stanza = mock('Stanza')
        stanza.stubs(:respond_to?).with(:to_xml).returns(true)
        data = '<bar />'
        stanza.expects(:to_xml).returns(data)
        @connection.expects(:send_data).with(data)
        client = Bersalis::Client.new
        client.connection = @connection
        client.write(stanza)
      end
    end
    
    context 'write_iq' do
      setup do
        @client = Bersalis::Client.new
        @client.stubs(:write)
      end
      
      should 'store a callback for the outgoing stanza' do
        stanza = mock('Stanza')
        stanza.stubs(:id).returns(1234)
        @client.write_iq(stanza)
        assert_equal @client.iq_callbacks[1234], stanza
      end
      
      should 'send the stanza' do
        stanza = mock('Stanza')
        stanza.stubs(:id).returns(1234)
        @client.expects(:write).with(stanza)
        @client.write_iq(stanza)
      end
    end
    
    context 'stanza_classes_for' do
      setup do
        @klass = mock('Stanza class')
        @opts = {
          :path => '/a/test/foo:path', 
          :namespaces => {'foo' => 'http://foo.com'}
        }
        Bersalis::KNOWN_STANZAS[@klass] = @opts
        @node = mock('Node')
        @node.stubs(:at)
      end
      
      should 'return a stanza class if node is recognised' do
        @node.expects(:at).with(@opts[:path], @opts[:namespaces]).returns(true)
        client = Bersalis::Client.new
        assert_equal client.send(:stanza_classes_for, @node), [@klass]
      end
      
      should 'return empty if the node is unrecognised' do
        @node.expects(:at).with(@opts[:path], @opts[:namespaces]).returns(nil)
        client = Bersalis::Client.new
        assert_equal client.send(:stanza_classes_for, @node), []
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
        client = Bersalis::Client.new
        assert_equal client.send(:handler_for, @klass, @node), @opts
      end
      
      should 'not return a recognised handler where a filter has been applied' do
        @opts[:filter] = '/nothing/to/see/here'
        @node.expects(:at).with(@opts[:filter], {}).returns(nil)
        Bersalis::Client::HANDLERS.expects(:select).returns([@opts])
        client = Bersalis::Client.new
        assert_equal client.send(:handler_for, @klass, @node), nil
      end
    end
    
    context 'callback_for' do
      setup do
        @client = Bersalis::Client.new
        @iq_klass = mock('An IQ class')
        @iq = mock('IQ')
        @iq.stubs(:class).returns(@iq_klass)
        @iq_klass.stubs(:new)
      end
      
      should 'return nil if stanza is not an iq result' do
        node = mock('Node')
        node.stubs(:at).returns(nil)
        assert_nil @client.send(:callback_for, node)
      end
      
      should 'return nil if no callback is found' do
        node = mock('Node')
        node.stubs(:at).returns({'id' => 1234})
        @client.iq_callbacks = {}
        assert_nil @client.send(:callback_for, node)
      end
      
      should 'call back if a corresponding outgoing iq is found' do
        node = mock('Node')
        node.stubs(:at).returns({'id' => 1234})
        @client.iq_callbacks[1234] = @iq
        @iq.expects(:succeed)
        @client.send(:callback_for, node)
      end
      
      should 'call back with an iq of the same type as the outgoing' do
        node = mock('Node')
        node.stubs(:at).returns({'id' => 1234})
        
        incoming_iq = mock('IQ')
        @iq_klass.stubs(:new).returns(incoming_iq)
        
        @client.iq_callbacks[1234] = @iq
        @iq.expects(:succeed).with(incoming_iq)
        @client.send(:callback_for, node)
      end
    end
  end
end