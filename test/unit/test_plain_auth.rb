require 'test_helper'

class TestPlainAuth < Test::Unit::TestCase
  context 'Bersalis::PlainAuth' do
    test_stanza "<auth xmlns=\"urn:ietf:params:xml:ns:xmpp-sasl\" mechanism=\"PLAIN\" />"
    should_create "<auth xmlns=\"urn:ietf:params:xml:ns:xmpp-sasl\" mechanism=\"PLAIN\"/>"
  end
end