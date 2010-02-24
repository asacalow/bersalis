module Bersalis
  class Iq < Stanza
    NODE_NAME = 'iq'
  
    attribute :type,  :path => '/iq'
    attribute :id,    :path => '/iq'
  end
  
  class Presence < Stanza
    NODE_NAME = 'presence'
  
    register '/presence'
  end
end