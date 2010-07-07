require 'test_helper'

class TestAuthSuccessful < Test::Unit::TestCase
  context 'Bersalis::AuthenticationSuccessful' do
    test_stanza "<success xmlns=\"urn:ietf:params:xml:ns:xmpp-sasl\" />"
  end
end