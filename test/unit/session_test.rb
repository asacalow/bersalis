require 'test_helper'

class SessionTest < Test::Unit::TestCase
  context 'Bersalis::Bind' do
    test_stanza "<iq type=\"get\"><bind xmlns=\"urn:ietf:params:xml:ns:xmpp-bind\"><jid>bob@example.com</jid><resource>test</resource></bind></iq>"
    should_have 'jid', 'bob@example.com'
    should_have 'resource', 'test'
  end
  
  context 'Bersalis::Session' do
    test_stanza "<iq type=\"get\"><session xmlns=\"urn:ietf:params:xml:ns:xmpp-session\" /></iq>"
  end
  
  context 'Bersalis::Features' do
    test_stanza "<features />"
  end
  
  context 'Bersalis::StartTLS' do
    test_stanza "<starttls xmlns=\"urn:ietf:params:xml:ns:xmpp-tls\"/>"
  end
  
  context 'Bersalis::StartTLSProceed' do
    test_stanza "<proceed xmlns=\"urn:ietf:params:xml:ns:xmpp-tls\"/>"
  end
end