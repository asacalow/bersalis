module Bersalis
  class Features < ReadOnlyStanza
    register '/features'
    # register '/stream:features', 'stream' => 'http://etherx.jabber.org/streams'
    
    def tls_required?
      !!self.node.at('/features/tls:starttls/tls:required', 'tls' => 'urn:ietf:params:xml:ns:xmpp-tls')
    end
  end
end