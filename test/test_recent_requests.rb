require 'test_helper'

class TestRecentRequests < Test::Unit::TestCase

  def test_request_added_to_recent_requests
    FakeWeb.clear_recent_requests
    3.times do
      FakeWeb.register_uri(:get, "http://example.com", :status => [200, "OK"])
      Net::HTTP.start("example.com") { |http| http.get("/") }
    end
    assert_equal 3, FakeWeb.recent_requests.size
  end

  def test_last_request_returns_most_recent_request
    FakeWeb.register_uri(:get, "http://example.com", :status => [200, "OK"])
    Net::HTTP.start("example.com") { |http| http.get("/") }
    assert_same FakeWeb.recent_requests.last, FakeWeb.last_request
  end

  def test_clear_recent_requests
    FakeWeb.register_uri(:get, "http://example.com", :status => [200, "OK"])
    Net::HTTP.start("example.com") { |http| http.get("/") }
    assert_not_equal 0, FakeWeb.recent_requests.size
    FakeWeb.clear_recent_requests
    assert_equal 0, FakeWeb.recent_requests.size
  end
end
