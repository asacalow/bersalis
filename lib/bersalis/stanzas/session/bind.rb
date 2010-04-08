module Bersalis
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
end