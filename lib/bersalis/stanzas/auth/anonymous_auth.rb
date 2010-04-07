module Bersalis
  class AnonymousAuth < AuthMechanism
    register '/auth:auth[@mechanism="ANONYMOUS"]', 'auth' => 'urn:ietf:params:xml:ns:xmpp-sasl'
    MECHANISM = 'ANONYMOUS'
  end
end