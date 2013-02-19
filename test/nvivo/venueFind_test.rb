require File.expand_path(File.join(File.dirname(__FILE__),"..","test_helper"))

module Rnvivo

  class VenueFind < MiniTest::Unit::TestCase

    def test_venue_find_should_raise_nvivo_timeout_if_timeout
      Nvivo.stubs(:get).raises(Timeout::Error)
      n = Nvivo.new(FAKE_API_KEY)
      assert_raises NvivoTimeoutError do
        response = n.venueFind('Sala Wadus')
      end
    end

    def test_venue_find_should_get_venues
      result_200_ok = {
          'response' => {
              'status' => 'success',
              'venues' => {
                  'venue' => [
                      {
                          'name' => 'Wadus room',
                          'url' => 'http://wadus.com/wadus-event'
                      },
                      {
                          'name' => 'Sala Wadus',
                          'url' => 'http://wadus.com/wadus-event-2'
                      }
                  ]
              }
          }
      }
      Nvivo.stubs(:get).returns(result_200_ok)
      n = Nvivo.new(FAKE_API_KEY)
      response = n.venueFind('Sala Wadus')
      assert_equal response, result_200_ok['response']['venues']['venue']
    end

    def test_venue_find_should_get_emtpy_venues
      result_200_ok = {
          'response' => {
              'status' => 'success'
          }
      }
      Nvivo.stubs(:get).returns(result_200_ok)
      n = Nvivo.new(FAKE_API_KEY)
      response = n.venueFind('Sala Wadus')
      assert_equal response, []
    end

    def test_venue_find_should_return_error
      result_error = {
          'response' => {
              'status' => 'error',
              'error'  => {
                  'id' => 7,
                  'message' => 'Error message'
              }
          }
      }
      Nvivo.stubs(:get).returns(result_error)
      n = Nvivo.new(FAKE_API_KEY)
      assert_raises NvivoResultError do
        response = n.venueFind('Sala Wadus')
      end
    end
  end
end