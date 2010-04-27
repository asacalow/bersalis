module Bersalis
  class Document < Nokogiri::XML::SAX::Document
    attr_accessor :receiver
  
    def initialize(receiver)
      self.receiver = receiver
    end
  
    def start_element_namespace(name, attrs = [], prefix = nil, uri = nil, ns = [])
      node_options = {
        :name => name, 
        :attrs => attrs, 
        :prefix => prefix, 
        :uri => uri, 
        :ns => ns
      }
      
      if is_stream?(node_options) 
        process_now(node_options)
        return
      end
    
      # if we're already building a stanza then assign the found node to the same xml document as it
      doc = stanza_building_in_progress? ? @current.document : Nokogiri::XML::Document.new
    
      # create a Nokogiri node from what we know…
      node = create_node(doc, node_options)
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
    
    def create_node(doc, opts)
      name = opts[:name]
      attrs = opts[:attrs]
      prefix = opts[:prefix]
      uri = opts[:uri]
      ns = opts[:ns]
      node = Node.new(name, doc)
      attrs.each {|a| node[a.localname] = a.value}
      ns.each do |ns|
        prefix, uri = ns
        node.add_namespace(prefix,uri)
      end
      
      node
    end
  
    def process(node)
      # we set this so we can use xpath across the whole node – see the method
      node.finish_up
      @current = nil # reset our pointer
    
      self.receiver.process(node)
    end
    
    def process_now(opts)
      node = create_node(Nokogiri::XML::Document.new, opts)
      process(node)
    end
    
    def is_stream?(opts)
      return (opts[:name] == 'stream') && (opts[:prefix] == 'stream')
    end
  
    def stanza_building_in_progress?
      !!@current
    end
  end
end