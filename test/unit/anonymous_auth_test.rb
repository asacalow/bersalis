require 'test_helper'

class AnonymousAuthTest < Test::Unit::TestCase
  context 'Bersalis::AnonymousAuth' do
    test_stanza "<auth xmlns=\"urn:ietf:params:xml:ns:xmpp-sasl\" mechanism=\"ANONYMOUS\" />"
    should_create "<auth xmlns=\"urn:ietf:params:xml:ns:xmpp-sasl\" mechanism=\"ANONYMOUS\"/>"
  end
end