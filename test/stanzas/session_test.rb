require File.join(File.dirname(__FILE__), '..', 'test_helper')

class RosterTest < Test::Unit::TestCase
  context 'Bersalis::RosterGet' do
    test_stanza "<iq type=\"get\"><query xmlns=\"jabber:iq:get\" /></iq>"
  end
end