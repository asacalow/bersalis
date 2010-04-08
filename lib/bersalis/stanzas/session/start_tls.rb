module Bersalis
  class StartTLS < Stanza
    register '/starttls:starttls', 'starttls' => 'urn:ietf:params:xml:ns:xmpp-tls'
    NODE_NAME = 'starttls'
    
    def self.setup(node)
      super(node)
      node.add_namespace(nil, 'urn:ietf:params:xml:ns:xmpp-tls')
    end
  end
end