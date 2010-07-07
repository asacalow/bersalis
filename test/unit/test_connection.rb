require 'test_helper'

class TestConnection < Test::Unit::TestCase
  context 'Connection' do
    setup do
      @client = Bersalis::Client.new
      @client.stubs(:start)
    end
    
    context 'initialising' do
      should 'wire together the connection and the given client' do
        connection = Bersalis::Connection.new('dummysig', @client)
        assert_equal @client.connection, connection
        assert_equal connection.client, @client
      end
      
      should 'start the client after the connection is initialised' do
        @client.expects(:start)
        connection = Bersalis::Connection.new('dummysig', @client)
      end
    end

    context 'starting' do
      should 'instantiate a parser' do
        Nokogiri::XML::SAX::PushParser.expects(:new)
        connection = Bersalis::Connection.new('dummysig', @client)
        connection.start
      end
    end
    
    context 'receiving data' do
      setup do
        @parser = mock('Parser')
        @connection = Bersalis::Connection.new('dummysig', @client)
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