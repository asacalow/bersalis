module Bersalis
  class DigestAuth < AuthMechanism
    register '/auth:auth[@mechanism="DIGEST-MD5"]', 'auth' => 'urn:ietf:params:xml:ns:xmpp-sasl'
    MECHANISM = 'DIGEST-MD5'
  end
end