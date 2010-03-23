require File.join(File.dirname(__FILE__), '..', 'test_helper')

class AuthTest < Test::Unit::TestCase
  context 'Bersalis::AnonymousAuth' do
    test_stanza "<auth xmlns=\"urn:ietf:params:xml:ns:xmpp-sasl\" mechanism=\"ANONYMOUS\" />"
    should_create "<auth xmlns=\"urn:ietf:params:xml:ns:xmpp-sasl\" mechanism=\"ANONYMOUS\"/>"
  end
  
  context 'Bersalis::PlainAuth' do
    test_stanza "<auth xmlns=\"urn:ietf:params:xml:ns:xmpp-sasl\" mechanism=\"PLAIN\" />"
    should_create "<auth xmlns=\"urn:ietf:params:xml:ns:xmpp-sasl\" mechanism=\"PLAIN\"/>"
  end
  
  context 'Bersalis::DigestAuth' do
    test_stanza "<auth xmlns=\"urn:ietf:params:xml:ns:xmpp-sasl\" mechanism=\"DIGEST-MD5\" />"
    should_create "<auth xmlns=\"urn:ietf:params:xml:ns:xmpp-sasl\" mechanism=\"DIGEST-MD5\"/>"
  end
  
  context 'Bersalis::AuthenticationSuccessful' do
    test_stanza "<success xmlns=\"urn:ietf:params:xml:ns:xmpp-sasl\" />"
  end
end