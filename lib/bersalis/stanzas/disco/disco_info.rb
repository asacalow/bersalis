module Bersalis
  class DiscoInfo < IQ
    register '/iq/disco_info:query', 'disco_info' => 'http://jabber.org/protocol/disco#info'
    
    def self.setup(node)
      node = super(node)
      query = node << Nokogiri::XML::Node.new('query', node.document)
      query.add_namespace(nil, 'http://jabber.org/protocol/disco#info')
      query
    end
  end
end