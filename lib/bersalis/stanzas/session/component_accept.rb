module Bersalis
  class ComponentAccept < ReadOnlyStanza
    register '/component_accept:stream', 'component_accept' => 'jabber:component:accept'

    attribute :from,  :path => '/ca:stream', :namespaces => {'ca' => 'jabber:component:accept'}
    attribute :id,    :path => '/ca:stream', :namespaces => {'ca' => 'jabber:component:accept'}
  end
end