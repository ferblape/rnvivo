require 'test/unit'
require File.expand_path(File.join(File.dirname(__FILE__), '/../lib/nvivo'))

class NvivoTest < Test::Unit::TestCase
  
  FAKE_API_KEY = 'wadus'
  
  # TODO
  # def test_should_timeout_if_request_time_is_greater_than_timeout
  #   n = Nvivo.new(FAKE_API_KEY, 1)
  #   n.cityGetEvents('Madrid')
  # end
  
  def test_should_not_get_city_events_without_city_param
    n = Nvivo.new(FAKE_API_KEY)
    assert_raises ArgumentError do
      n.cityGetEvents()
    end    
  end

  # TODO
  # def test_should_get_city_events_if_city_param
  #   Nvivo.stubs(:get).returns(Hpricot.open(File.open(File.expand_path(File.join(File.dirname(__FILE__), 'city.getEvents=London'))).read))
  #   n = Nvivo.new(FAKE_API_KEY)
  #   response = n.cityGetEvents('Madrid')
  #   assert true
  # end
  
end
