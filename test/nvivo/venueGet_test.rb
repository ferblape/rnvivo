require File.expand_path(File.join(File.dirname(__FILE__),"..","test_helper"))

module Rnvivo

  class VenueGet < MiniTest::Unit::TestCase

    def test_venue_get_should_raise_nvivo_timeout_if_timeout
      Nvivo.stubs(:get).raises(Timeout::Error)
      n = Nvivo.new(FAKE_API_KEY)
      assert_raises NvivoTimeoutError do
        response = n.venueGet('Sala Wadus')
      end
    end

    def test_venue_get_should_get_venues
      result_200_ok = {
          'response' => {
              'status' => 'success',
              'venue' => {
                      'name' => 'Wadus room',
                      'url' => 'http://wadus.com/wadus-event'
              }
          }
      }
      Nvivo.stubs(:get).returns(result_200_ok)
      n = Nvivo.new(FAKE_API_KEY)
      response = n.venueGet('91')
      assert_equal response, result_200_ok['response']['venue']
    end

    def test_venue_get_should_get_emtpy_venues
      result_200_ok = {
          'response' => {
              'status' => 'success'
          }
      }
      Nvivo.stubs(:get).returns(result_200_ok)
      n = Nvivo.new(FAKE_API_KEY)
      response = n.venueGet('91')
      assert_equal response, []
    end

    def test_venue_get_should_return_error
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
        response = n.venueGet('91')
      end
    end
  end
end
