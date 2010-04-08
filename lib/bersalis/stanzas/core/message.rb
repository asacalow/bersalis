module Bersalis
  class Message < Stanza
    NODE_NAME = 'message'
    
    register '/message'
    
    attribute :type, :path => '/message'
    content   :body, :path => '/message'
  end
end