require 'test_helper'
include Bersalis

class TestBasicComponent < Test::Unit::TestCase
  context 'BasicComponent' do
    testing BasicComponent
    
    should_handle stanza_fixture(:component_accept),  :handle_component_accept
    should_handle stanza_fixture(:disco_info),        :handle_disco_info
    
    context 'handlers' do
      setup do
        @component = BasicComponent.new(:host => 'xmpp.example.com', :secret => 'unguess4ble')
        @component.stubs(:write)
      end
      
      context 'handle_component_accept' do
        setup do
          @component_accept = ComponentAccept.new(nil)
          @component_accept.stubs(:id).returns('123abc')
        end
        
        should 'respond with a Handshake stanza' do
          @component.stubs(:write) do |stanza|
            assert_kind_of Handshake, stanza
          end
          @component.handle_component_accept(@component_accept)
        end
        
        should 'set the credentials on the handshake' do
          handshake = mock('Handshake')
          Handshake.stubs(:create).returns(handshake)
          handshake.expects(:set_credentials).with(
            :id => '123abc',
            :secret => 'unguess4ble'
          )
          @component.handle_component_accept(@component_accept)
        end
      end
      
      context 'handle_disco_info' do
        should 'respond with a DiscoInfo stanza' do
          disco_info = DiscoInfo.new(nil)
          disco_info.stubs(:reply!)
          @component.stubs(:write) do |stanza|
            assert_kind_of DiscoInfo, stanza
          end
          @component.handle_disco_info(disco_info)
        end
      end
    end
  end
end