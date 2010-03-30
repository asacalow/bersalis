module Bersalis
  class Node < Nokogiri::XML::Node
    def self.new(name, doc=Nokogiri::XML::Document.new)
      super(name, doc)
    end
    
    # we do this so we can use the at method below to search the entire node
    def finish_up
      self.document.root = self
    end
    
    def at(*args)
      self.document.at(*args)
    end
  end
end