module Bersalis
  class Features < ReadOnlyStanza
    register '/features'
    # register '/stream:features', 'stream' => 'http://etherx.jabber.org/streams'
    
    def tls_required?
      !!self.node.at('/features/tls:starttls/tls:required', 'tls' => 'urn:ietf:params:xml:ns:xmpp-tls')
    end
  end

  class Bind < IQ
    register '/iq/bind:bind', 'bind' => 'urn:ietf:params:xml:ns:xmpp-bind'
    
    content :jid,       :path => '//bind:jid',      :namespaces => {'bind' => 'urn:ietf:params:xml:ns:xmpp-bind'}
    content :resource,  :path => '//bind:resource', :namespaces => {'bind' => 'urn:ietf:params:xml:ns:xmpp-bind'}
  
    def self.setup(node)
      node = super(node)
      bind = node << Nokogiri::XML::Node.new('bind', node.document)
      bind.add_namespace(nil, 'urn:ietf:params:xml:ns:xmpp-bind')
      bind << Nokogiri::XML::Node.new('jid', node.document)
      bind << Nokogiri::XML::Node.new('resource', node.document)
      node
    end
  end

  class Session < IQ
    register '/iq/session:session', 'session' => 'urn:ietf:params:xml:ns:xmpp-session'
  
    def self.setup(node)
      node = super(node)
      session = node << Nokogiri::XML::Node.new('session', node.document)
      session.add_namespace(nil, 'urn:ietf:params:xml:ns:xmpp-session')
      node
    end
  end
  
  class StartTLS < Stanza
    register '/starttls:starttls', 'starttls' => 'urn:ietf:params:xml:ns:xmpp-tls'
    NODE_NAME = 'starttls'
    
    def self.setup(node)
      super(node)
      node.add_namespace(nil, 'urn:ietf:params:xml:ns:xmpp-tls')
    end
  end
  
  class StartTLSProceed < Stanza
    register '/starttls:proceed', 'starttls' => 'urn:ietf:params:xml:ns:xmpp-tls'
    NODE_NAME = 'proceed'
    
    def self.setup(node)
      super(node)
      node.add_namespace(nil, 'urn:ietf:params:xml:ns:xmpp-tls')
    end
  end
end