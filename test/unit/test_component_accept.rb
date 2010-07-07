require 'test_helper'

class TestComponentAccept < Test::Unit::TestCase
  context 'Bersalis::ComponentAccept' do
    test_stanza "<stream xmlns=\"jabber:component:accept\" from=\"xmpp.example.com\" id=\"test1234\">"
    should_have 'from', 'xmpp.example.com'
    should_have 'id', 'test1234'
  end
end