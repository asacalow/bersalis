module Bersalis
  class IQ < Stanza
    NODE_NAME = 'iq'
    
    register '/iq'
  
    attribute :type,  :path => '/iq'
    attribute :id,    :path => '/iq'
    
    def setup(node)
      node[:id] = generate_id
      node
    end
    
    def generate_id
      # TODO
      "1234"
    end
  end
  
  class Presence < Stanza
    NODE_NAME = 'presence'
  
    register '/presence'
  end
  
  class Message < Stanza
    NODE_NAME = 'message'
    
    register '/message'
    
    attribute :type, :path => '/message'
    content   :body, :path => '/message'
  end
end