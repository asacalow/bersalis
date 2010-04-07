module Bersalis
  class AuthMechanism < Auth
    def self.setup(node)
      node = super(node)
      node.add_namespace(nil, 'urn:ietf:params:xml:ns:xmpp-sasl')
      node['mechanism'] = self::MECHANISM
      node
    end
  end
end