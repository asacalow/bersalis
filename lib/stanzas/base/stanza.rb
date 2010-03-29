module Bersalis
  class Stanza < ReadOnlyStanza
    def self.create(attributes={})
      node = Node.new(self::NODE_NAME)
      node.finish_up
      self.setup(node)
      return self.new(node, attributes)
    end

    # override this method and build your stanza here like so:
    # def self.setup(node)
    #     node = super(node)
    #     Nokogiri::XML::Builder.with(node) do |xml|
    #       # do cool stuff
    #     end
    #     # and now return the node from which child classes of this stanza build
    #   end
    def self.setup(node)
      node
    end
    
    def to_xml(*args)
      self.node.to_xml(*args)
    end
    
    def reply!
      self.to, self.from = self.from, self.to
    end
  end
end