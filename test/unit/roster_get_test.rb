require 'test_helper'

class RosterGetTest < Test::Unit::TestCase
  context 'Bersalis::RosterGet' do
    test_stanza "<iq type=\"get\"><query xmlns=\"jabber:iq:get\" /></iq>"
  end
end