require File.join(File.dirname(__FILE__), '..', 'test_helper')

class CoreTest < Test::Unit::TestCase
  context 'Bersalis::IQ' do
    should_be_recognised_as "<iq to=\"bob@example.com\" from=\"jim@example.com\" type=\"get\"><foo /></iq>"
    should 'generate a unique id for itself'
    should 'have a type'
  end
  
  context 'Bersalis::Presence' do
    should 'be recognised'
  end
  
  context 'Bersalis::Message' do
    should 'be recognised'
    should 'have a type'
    should 'have a body'
  end
end