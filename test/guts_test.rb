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

# class ClientTest < Test::Unit::TestCase
#   context 'starting' do
#     should 'set up the connection'
#     should 'send a stream start message'
#   end
#   
#   should 'restarting should start again'
#   
#   context 'creating a handler' do
#     should 'add a handler in the appropriate format'
#   end
#   
#   context 'processing a parsed node' do
#     should 'not do anything with an unrecognised stanza'
#     
#     context 'of a recognised stanza type' do
#       should 'look for a handler'
#       should 'apply the stanza filter for a recognised handler'
#     end
#   end
#   
#   context 'sending data' do
#     should 'convert the stanza to xml'
#     should 'write data to the connection'
#   end
# end
# 
# class DocumentTest < Test::Unit::TestCase
#   should 'process a complete stanza'
#   should 'not process an incomplete stanza'
# end