require File.expand_path(File.join(File.dirname(__FILE__),"..","test_helper"))

module Rnvivo

  class UserGetEvents < MiniTest::Unit::TestCase

    def test_user_get_events_should_raise_nvivo_timeout_if_timeout
      Nvivo.stubs(:get).raises(Timeout::Error)
      n = Nvivo.new(FAKE_API_KEY)
      assert_raises NvivoTimeoutError do
        response = n.userGetEvents('wadus')
      end
    end

    def test_user_get_events_should_get_user_events_if_user_param
      result_200_ok = {
          'response' => {
              'status' => 'success',
              'events' => {
                  'event' => [
                      {
                          'name' => 'Wadus event',
                          'url' => 'http://wadus.com/wadus-event'
                      },
                      {
                          'name' => 'Wadus event 2',
                          'url' => 'http://wadus.com/wadus-event-2'
                      }
                  ]
              }
          }
      }
      Nvivo.stubs(:get).returns(result_200_ok)
      n = Nvivo.new(FAKE_API_KEY)
      response = n.userGetEvents('wadus')
      assert_equal response, result_200_ok['response']['events']['event']
    end

    def test_user_get_events_should_get_user_events_emtpy
      result_200_ok = {
          'response' => {
              'status' => 'success'
          }
      }
      Nvivo.stubs(:get).returns(result_200_ok)
      n = Nvivo.new(FAKE_API_KEY)
      response = n.userGetEvents('wadus')
      assert_equal response, []
    end

    def test_user_get_events_should_return_error
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
        response = n.userGetEvents('wadus')
      end
    end
  end
end