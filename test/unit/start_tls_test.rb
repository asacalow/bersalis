require 'test_helper'

class StartTLSTest < Test::Unit::TestCase
  context 'Bersalis::StartTLS' do
    test_stanza "<starttls xmlns=\"urn:ietf:params:xml:ns:xmpp-tls\"/>"
  end
end