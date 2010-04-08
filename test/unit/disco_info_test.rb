require 'test_helper'

class DiscoInfoTest < Test::Unit::TestCase
  context 'Bersalis::DiscoInfo' do
    test_stanza "<iq type=\"get\"><query xmlns=\"http://jabber.org/protocol/disco#info\"/></iq>"
    should_create("<iq id=\"1\"><query xmlns=\"http://jabber.org/protocol/disco#info\"/></iq>")
  end
end