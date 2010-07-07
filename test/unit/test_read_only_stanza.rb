require 'test_helper'

class TestReadOnlyStanza < Test::Unit::TestCase
  should 'register a stanza type in the appropriate format' do
    class DummyStanza < Bersalis::ReadOnlyStanza; end
    path = '/some/identifying/foo:path'
    namespaces = {'foo' => 'http://foo.com'}
    DummyStanza.register(path, namespaces)
    registration = Bersalis::KNOWN_STANZAS[DummyStanza]
    
    assert_equal registration[:path], path
    assert_equal registration[:namespaces], namespaces
  end
  
  context 'at' do
    should 'return the node found at the given path' do
      node = Bersalis::Node.new('foo')
      bar = node << Bersalis::Node.new('bar', node.document)
      node.finish_up
      stanza = Bersalis::ReadOnlyStanza.new(node)
      assert_equal stanza.at('//bar'), bar
    end
  end
  
  context 'self.attribute' do
    setup do
      @node = Bersalis::Node.new('foo')
      @node.finish_up
      @bar = @node << Bersalis::Node.new('bar', @node.document)
    end
    
    should 'create a setter that points to the right place' do
      class DummyStanza < Bersalis::ReadOnlyStanza; end
      DummyStanza.attribute('bar', :path => '//bar')
      stanza = DummyStanza.new(@node)
      stanza.bar = 'baz'
      assert_equal @bar[:bar], stanza.bar
    end
    
    should 'create a getter that points to the right place' do
      class DummyStanza < Bersalis::ReadOnlyStanza; end
      DummyStanza.attribute('bar', :path => '//bar')
      stanza = DummyStanza.new(@node)
      @bar['bar'] = 'bazzzz'
      assert_equal @bar[:bar], stanza.bar
    end
  end
  
  context 'self.content' do
    setup do
      @node = Bersalis::Node.new('foo')
      @node.finish_up
      @bar = @node << Bersalis::Node.new('bar', @node.document)
    end
    
    should 'create a setter that points to the right place' do
      class DummyStanza < Bersalis::ReadOnlyStanza; end
      DummyStanza.content('bar', :path => '//bar')
      stanza = DummyStanza.new(@node)
      stanza.bar = 'baz'
      assert_equal @bar.content, stanza.bar
    end
    
    should 'create a getter that points to the right place' do
      class DummyStanza < Bersalis::ReadOnlyStanza; end
      DummyStanza.content('bar', :path => '//bar')
      stanza = DummyStanza.new(@node)
      @bar.content = 'bazzzz'
      assert_equal @bar.content, stanza.bar
    end
  end
end