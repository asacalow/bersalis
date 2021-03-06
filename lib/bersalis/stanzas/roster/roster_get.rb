module Bersalis
  class RosterGet < IQ
    register '/iq/rosterget:query', 'rosterget' => 'jabber:iq:get'
    
    def self.setup(node)
      node = super(node)
      query = node << Nokogiri::XML::Node.new('query', node.document)
      query.add_namespace(nil, 'jabber:iq:get')
      query
    end
  end
end