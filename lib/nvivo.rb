%w{rubygems httparty mocha timeout}.each { |x| require x }

$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

class NvivoTimeoutError < StandardError; end
class NvivoError < StandardError 
  attr_reader :message
  def initialize(message)
    @message = message
  end

end


class String
  def blank?
    nil? || self.strip == ""
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

  def cityGetEvents(city, country)
    raise ArgumentError, 'You must indicate a city' if city.blank?
    raise ArgumentError, 'You must indicate a country' if country.blank?
    
    options = { :query => { :method => 'city.getEvents', :city => city, :api_key => @api_key, :country_iso => country } }
    
    begin
      status = Timeout::timeout(@timeout) {
        result = self.class.get(API_URL, options)
        if result['response']['status'] == 'success'
          if result['response']['events'].nil?
            return []
          else
            return result['response']['events']['event']
          end
        elsif result['response']['status'] == 'error'
          raise NvivoError.new(result['response']['error'])
        end
      }
    rescue Timeout::Error
      raise NvivoTimeoutError
    end
  end

  def artistGetEvents(artist, country='all', past = false)
    raise ArgumentError, 'You must indicate an artist' if artist.blank?

    options = { :query => {
        :method => 'artist.getEvents',
        :artist => artist,
        :api_key => @api_key,
        :county_iso => country,
        :past => past}
    }

    begin
      status = Timeout::timeout(@timeout) {
        result = self.class.get(API_URL, options)

        if result['response']['status'] == 'success'
          if result['response']['events'].nil?
            []
          else
            result['response']['events']['event']
          end
        elsif result['response']['status'] == 'error'
          raise NvivoError.new(result['response']['error'])
        end
      }
    rescue Timeout::Error
      raise NvivoTimeoutError
    end
  end
end
