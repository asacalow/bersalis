require 'test_helper'

class DocumentTest < Test::Unit::TestCase
  context 'Document' do
    setup do
      @client = mock('Client')
      @document = Bersalis::Document.new(@client)
      @parser = Nokogiri::XML::SAX::PushParser.new(@document)
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
      @client.stubs(:process).with do |node|
        assert_kind_of Bersalis::Node, node
        assert_equal node.name, 'foo'
        true
      end
      @parser << "<foo bar=\"foobar\"><baz /></foo>"
    end
    
    should 'process an unclosed stream node immediately' do
      @document.expects(:process_now).returns(nil)
      @parser << "<stream:stream xmlns:stream=\"http://etherx.jabber.org/streams\">"
    end
  end
end