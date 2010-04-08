module Bersalis
  class StartTLSProceed < Stanza
    register '/starttls:proceed', 'starttls' => 'urn:ietf:params:xml:ns:xmpp-tls'
    NODE_NAME = 'proceed'
    
    def self.setup(node)
      super(node)
      node.add_namespace(nil, 'urn:ietf:params:xml:ns:xmpp-tls')
    end
  end
end