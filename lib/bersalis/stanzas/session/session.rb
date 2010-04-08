module Bersalis
  class Session < IQ
    register '/iq/session:session', 'session' => 'urn:ietf:params:xml:ns:xmpp-session'
  
    def self.setup(node)
      node = super(node)
      session = node << Nokogiri::XML::Node.new('session', node.document)
      session.add_namespace(nil, 'urn:ietf:params:xml:ns:xmpp-session')
      node
    end
  end
end