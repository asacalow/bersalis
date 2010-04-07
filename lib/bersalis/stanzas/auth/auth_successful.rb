module Bersalis
  class AuthenticationSuccessful < ReadOnlyStanza
    register '/auth:success', 'auth' => 'urn:ietf:params:xml:ns:xmpp-sasl'
  end
end