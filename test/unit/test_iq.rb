require 'test_helper'

class TestIq < Test::Unit::TestCase
  context 'Bersalis::IQ' do
    test_stanza "<iq id=\"123\" to=\"bob@example.com\" from=\"jim@example.com\" type=\"get\"><foo /></iq>"
    should_have 'id', '123'
    should_have 'type', 'get'
    
    should 'generate a unique id for itself' do
      iq = mock('IQ')
      Bersalis::IQ.expects('increment_id!').returns('123')
      Bersalis::IQ.create
    end
    
    should 'generate a new id each time' do
      first = Bersalis::IQ.create
      second = Bersalis::IQ.create
      assert_not_equal first.id, second.id
    end
    
    should 'be deferrable' do
      assert_contains Bersalis::IQ.ancestors, EventMachine::Deferrable
    end
  end
end