%w{rubygems httparty mocha timeout}.each { |x| require x }

$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

class NvivoTimeoutError < StandardError; end
class NvivoInvalidResponse < StandardError 
  attr_reader :message
  def initialize(message)
    @message = message
  end
  
end

class Nvivo
  
  include HTTParty
  
  API_URL = "http://www.nvivo.es/api/request.php"
  format :xml
  attr_reader :api_key, :timeout
  
  def initialize(key, timeout = 30)
    @api_key = key
    @timeout = timeout
  end

  def cityGetEvents(city)
    raise ArgumentError, 'You must indicate a city' if city.blank?
    
    options = { :query => { :method => 'city.getEvents', :city => city, :api_key => @api_key } }
    
    begin
      status = Timeout::timeout(@timeout) {
        return self.class.get(API_URL, options)['response']['events']['event']
      }
    rescue Timeout::Error
      raise NvivoTimeoutError
    rescue NoMethodError => e
      raise NvivoInvalidResponse.new($!)
    end
  end

end
