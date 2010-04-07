require 'test_helper'

class DigestAuthTest < Test::Unit::TestCase
  context 'Bersalis::DigestAuth' do
    test_stanza "<auth xmlns=\"urn:ietf:params:xml:ns:xmpp-sasl\" mechanism=\"DIGEST-MD5\" />"
    should_create "<auth xmlns=\"urn:ietf:params:xml:ns:xmpp-sasl\" mechanism=\"DIGEST-MD5\"/>"
  end
end