require 'test_helper'

class TestMessage < Test::Unit::TestCase
  context 'Bersalis::Message' do
    test_stanza "<message type=\"chat\">Hello there.</message>"
    should_have 'type', 'chat'
    should_have 'body', 'Hello there.'
  end
end