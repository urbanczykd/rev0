require 'active_support/test_case'
require 'shoulda-context'
require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir = 'test/vcr_cassettes'
  c.hook_into :webmock
  c.allow_http_connections_when_no_cassette = false
end

$:.unshift File.expand_path('../../', __FILE__)
