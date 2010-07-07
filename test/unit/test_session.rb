require 'test_helper'

class TestSession < Test::Unit::TestCase
  context 'Bersalis::Session' do
    test_stanza "<iq type=\"get\"><session xmlns=\"urn:ietf:params:xml:ns:xmpp-session\" /></iq>"
  end
end