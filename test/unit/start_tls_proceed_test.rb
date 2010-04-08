require 'test_helper'

class StartTLSProceedTest < Test::Unit::TestCase
  context 'Bersalis::StartTLSProceed' do
    test_stanza "<proceed xmlns=\"urn:ietf:params:xml:ns:xmpp-tls\"/>"
  end
end