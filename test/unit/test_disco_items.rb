require 'test_helper'

class TestDiscoItems < Test::Unit::TestCase
  context 'Bersalis::DiscoItems' do
    test_stanza "<iq type=\"get\"><query xmlns=\"http://jabber.org/protocol/disco#items\"/></iq>"
  end
end