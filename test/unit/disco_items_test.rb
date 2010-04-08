require 'test_helper'

class DiscoItemsTest < Test::Unit::TestCase
  context 'Bersalis::DiscoItems' do
    test_stanza "<iq type=\"get\"><query xmlns=\"http://jabber.org/protocol/disco#items\"/></iq>"
  end
end