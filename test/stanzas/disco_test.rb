require File.join(File.dirname(__FILE__), '..', 'test_helper')

class DiscoTest < Test::Unit::TestCase
  context 'Bersalis::DiscoInfo' do
    test_stanza "<iq type=\"get\"><query xmlns=\"http://jabber.org/protocol/disco#info\"/></iq>"
    should_create("<iq id=\"1\"><query xmlns=\"http://jabber.org/protocol/disco#info\"/></iq>")
  end
  
  context 'Bersalis::DiscoItems' do
    test_stanza "<iq type=\"get\"><query xmlns=\"http://jabber.org/protocol/disco#items\"/></iq>"
  end
end