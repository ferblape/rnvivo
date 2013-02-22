%w{rubygems httparty timeout}.each { |x| require x }

require 'core_ext/string'

$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

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

    def cityGetEvents(city, country = 'all')
      raise ArgumentError, 'You must indicate a city' if city.blank?

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

    def venueGetEvents(venue_id, past = false)
      raise ArgumentError, 'You must indicate a venue' if venue_id.blank?

      options = query 'venue.getEvents',
                      :venue_id => venue_id,
                      :past => past

      deal_with_response_for options do |r|
        return nested_result r, 'response', 'events', 'event'
      end
    end

    def userGetEvents(user)
      raise ArgumentError, 'You must indicate a user' if user.blank?

      options = query 'user.getEvents',
                      :user => user

      deal_with_response_for(options) do |r|
        return nested_result r, 'response', 'events', 'event'
      end
    end

    def venueFind(venue_name, country='all')
      raise ArgumentError, 'You must indicate a venue name' if venue_name.blank?

      options = query 'venue.find',
                      :venue_name => venue_name,
                      :country_iso => country

      deal_with_response_for options do |r|
        return nested_result r, 'response', 'venues', 'venue'
      end
    end

    def venueGet(venue_id)
      raise ArgumentError, 'You must inidicate a venue id' if venue_id.blank?

      options = query 'venue.get',
                      :venue_id => venue_id

      deal_with_response_for options do |r|
        return nested_result r, 'response', 'venue'
      end
    end

    protected

    def query(method, *args)
      {
        query: args.first.merge({
          method: method, api_key: @api_key
        })
      }
    end

    def nested_result(result, *args)
      args.inject(result) do |memo, obj|
        memo && memo[obj.to_s]
      end || []
    end

    def deal_with_response_for(options, &block)
      Timeout::timeout(@timeout) do
        deal_with_result self.class.get(API_URL, options), &block
      end
    rescue Timeout::Error
      raise NvivoTimeoutError
    end

    def deal_with_result(result)
      if result['response']['status'] == 'success' && block_given?
        return yield result
      elsif result['response']['status'] == 'error'
        return raise NvivoResultError.new(result['response']['error'])
      end
    end
  end
end
