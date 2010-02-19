module Bersalis
  class Auth < Stanza
    NODE_NAME = 'auth'
  end

  class AnonymousAuth < Auth
    def self.setup(node)
      node = super(node)
      node.add_namespace(nil, 'urn:ietf:params:xml:ns:xmpp-sasl')
      node['mechanism'] = 'ANONYMOUS'
      node
    end
  end

  class PlainAuth < Auth
    def self.setup(node)
      node = super(node)
      node.add_namespace(nil, 'urn:ietf:params:xml:ns:xmpp-sasl')
      node['mechanism'] = 'PLAIN'
      node
    end
  
    def set_credentials(opts)
      self.node.content = b64("#{opts[:jid]}\x00#{opts[:username]}\x00#{opts[:password]}")
    end
  
    private
  
    def b64(str)
      [str].pack('m').gsub(/\s/,'')
    end
  end
  
  class AuthenticationSuccessful < ReadOnlyStanza
    register '/auth:success', 'auth' => 'urn:ietf:params:xml:ns:xmpp-sasl'
  end
end