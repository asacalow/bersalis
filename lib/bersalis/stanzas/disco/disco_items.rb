module Bersalis
  class DiscoItems < IQ
    register '/iq/disco_items:query', 'disco_items' => 'http://jabber.org/protocol/disco#items'
    
    def self.setup(node)
      node = super(node)
      query = node << Nokogiri::XML::Node.new('query', node.document)
      query.add_namespace(nil, 'http://jabber.org/protocol/disco#items')
      query
    end
  end
end