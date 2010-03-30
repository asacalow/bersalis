module Bersalis
  class Document < Nokogiri::XML::SAX::Document
    attr_accessor :receiver
  
    def initialize(receiver)
      self.receiver = receiver
    end
  
    def start_element_namespace(name, attrs = [], prefix = nil, uri = nil, ns = [])
      return if name == 'stream' # this tag only gets closed when the connection is closed so we want to ignore this for now
      # TODO: Create a Stream object which captures some of this stuff.
    
      # if we're already building a stanza then assign the found node to the same xml document as it
      doc = stanza_building_in_progress? ? @current.document : Nokogiri::XML::Document.new
    
      # create a Nokogiri node from what we know…
      node = Node.new(name, doc)
      attrs.each {|a| node[a.localname] = a.value}
      ns.each do |ns|
        prefix, uri = ns
        node.add_namespace(prefix,uri)
      end
      @current << node if @current # down the tree
      @current = node
    end
  
    def end_element_namespace(name, attrs = [], prefix = nil, uri = nil, ns = [])
      return if name == 'stream' # TODO: Handle this (see above!)
    
      # if there's a parent node we're not done parsing here so return
      if @current.parent
        @current = @current.parent
        return
      end
    
      # otherwise process the node ready for handling
      process(@current)
    end
  
    def characters(chars = '')
      @current << Nokogiri::XML::Text.new(chars, @current.document) if @current
    end
  
    private
  
    def process(node)
      # we set this so we can use xpath across the whole node – see the method
      node.finish_up
      @current = nil # reset our pointer
    
      self.receiver.process(node)
    end
  
    def stanza_building_in_progress?
      !!@current
    end
  end
end