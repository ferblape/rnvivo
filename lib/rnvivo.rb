%w{rubygems httparty timeout}.each { |x| require x }

$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))



class String
  def blank?
    self !~ /[^[:space:]]/
  end
end

module Rnvivo

  class NvivoError < StandardError; end
  class NvivoTimeoutError < NvivoError; end
  class NvivoResultError < NvivoError
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

    def cityGetEvents(city, country)
      raise ArgumentError, 'You must indicate a city' if city.blank?
      raise ArgumentError, 'You must indicate a country' if country.blank?

      options = query 'city.getEvents',
                      :city => city,
                      :country_iso => country

      deal_with_response_for options do |r|
        return nested_result r, 'response', 'events', 'event'
      end
    end

    def artistGetEvents(artist, country='all', past = false)
      raise ArgumentError, 'You must indicate an artist' if artist.blank?

      options = query 'artist.getEvents',
                      :artist => artist,
                      :county_iso => country,
                      :past => past

      deal_with_response_for options do |r|
        return nested_result r, 'response', 'events', 'event'
      end
    end

    protected

    def query method, *args
      {query: args.first.merge({method: method, api_key: @api_key})}
    end

    def nested_result result, *args
      args.inject(result) do |memo, obj|
        memo && memo[obj.to_s]
      end || []
    end

    def deal_with_response_for options, &block
      Timeout::timeout(@timeout) do
        deal_with_result self.class.get(API_URL, options), &block
      end
    rescue Timeout::Error
      raise NvivoTimeoutError
    end

    def deal_with_result result
      if result['response']['status'] == 'success' && block_given?
        return yield result
      elsif result['response']['status'] == 'error'
        return raise NvivoResultError.new(result['response']['error'])
      end
    end
  end
end
