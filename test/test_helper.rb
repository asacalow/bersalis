require 'rubygems'
require 'test/unit'
require 'shoulda'
require 'mocha'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'bersalis'

class Test::Unit::TestCase
  def self.test_stanza(xml_string)
    @stanza = xml_string
    
    # generate the class name from the context
    @test_class = constantize(Shoulda.current_context.name)
    
    # test to ensure that the given xml matches the stanza
    self.should_be_recognised
  end
  
  def self.should_be_recognised
    # these are required for scoping purposes
    stanza = @stanza
    test_class = @test_class
    
    should 'be recognised' do
      connection = mock('Connection')
      client = Bersalis::Client.new(connection)
      document = Nokogiri::XML::Document.parse(stanza)
      assert_contains client.send(:stanza_classes_for, document.root), test_class
    end
  end
  
  def self.should_have(attribute_name, value)
    # these are required for scoping purposes
    stanza = @stanza
    test_class = @test_class
    
    should "have a valid getter '#{attribute_name}'" do
      connection = mock('Connection')
      client = Bersalis::Client.new(connection)
      document = Nokogiri::XML::Document.parse(stanza)
      instance = test_class.new(document.root)
      assert_equal instance.send("#{attribute_name}"), value
    end
    
    should "have a valid setter '#{attribute_name}'" do
      connection = mock('Connection')
      client = Bersalis::Client.new(connection)
      document = Nokogiri::XML::Document.parse(stanza)
      instance = test_class.new(document.root)
      value = '1234thisisatestvalueabcd'
      instance.send("#{attribute_name}=", value)
      assert_equal instance.send("#{attribute_name}"), value
    end
  end
  
  # borrowed from Rails::ActiveSupport
  def self.constantize(camel_cased_word)
    names = camel_cased_word.split('::')
    names.shift if names.empty? || names.first.empty?

    constant = Object
    names.each do |name|
      constant = constant.const_defined?(name) ? constant.const_get(name) : constant.const_missing(name)
    end
    constant
  end
end