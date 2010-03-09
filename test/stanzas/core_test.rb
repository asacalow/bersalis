require File.join(File.dirname(__FILE__), '..', 'test_helper')

class CoreTest < Test::Unit::TestCase
  context 'Bersalis::IQ' do
    should_be_recognised_as "<iq to=\"bob@example.com\" from=\"jim@example.com\" type=\"get\"><foo /></iq>"
    
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
    
    should 'have a type' do
      
    end
  end
  
  context 'Bersalis::Presence' do
    should_be_recognised_as "<presence />"
  end
  
  context 'Bersalis::Message' do
    should_be_recognised_as "<message type=\"chat\">Hello there.</message>"
    should 'have a type'
    should 'have a body'
  end
end