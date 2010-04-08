require 'test_helper'

class BindTest < Test::Unit::TestCase
  context 'Bersalis::Bind' do
    test_stanza "<iq type=\"get\"><bind xmlns=\"urn:ietf:params:xml:ns:xmpp-bind\"><jid>bob@example.com</jid><resource>test</resource></bind></iq>"
    should_have 'jid', 'bob@example.com'
    should_have 'resource', 'test'
  end
end