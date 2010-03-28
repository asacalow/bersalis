require 'rubygems'
require 'test/unit'
require 'shoulda'
require 'mocha'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'bersalis'

class Test::Unit::TestCase
  def self.testing(klass)
    @test_class = klass
  end
  
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
      client = Bersalis::Client.new
      document = Nokogiri::XML::Document.parse(stanza)
      assert_contains client.send(:stanza_classes_for, document.root), test_class
    end
  end
  
  def self.should_have(attribute_name, value)
    # these are required for scoping purposes
    stanza = @stanza
    test_class = @test_class
    
    should "have a valid getter '#{attribute_name}'" do
      client = Bersalis::Client.new
      document = Nokogiri::XML::Document.parse(stanza)
      instance = test_class.new(document.root)
      assert_equal instance.send("#{attribute_name}"), value
    end
    
    should "have a valid setter '#{attribute_name}'" do
      client = Bersalis::Client.new
      document = Nokogiri::XML::Document.parse(stanza)
      instance = test_class.new(document.root)
      value = '1234thisisatestvalueabcd'
      instance.send("#{attribute_name}=", value)
      assert_equal instance.send("#{attribute_name}"), value
    end
  end
  
  def self.should_create(xml_string)
    test_class = @test_class
    
    should 'generate the correct xml on creation' do
      xml = test_class.create.to_xml(:indent => 0) # we pass an indent of 0 here so we don't have to indent our supplied test xml
      xml = xml.split(/\n/).join # remove newlines
      
      assert_equal xml_string, xml
    end
  end
  
  def self.should_handle(stanza, method)
    test_class = @test_class
    
    should "use the method '#{method}' to handle '#{stanza}'" do
       client = test_class.new(:jid => 'bob@example.com', :password => 'unguess4ble')
       client.stubs(:write)
       connection = Bersalis::Connection.new('dummysig', client)
       connection.stubs(:start_tls)
       
       client.expects(method)
       connection.receive_data(stanza) # simulate stanza coming in over the wire
    end
  end
  
  def self.stanza_fixture(stanza_name)
    File.open(File.join(File.dirname(__FILE__), 'fixtures', "#{stanza_name.to_s}.xml")).read
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