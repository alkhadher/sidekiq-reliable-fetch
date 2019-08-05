# frozen_string_literal: true

require_relative '../../lib/sidekiq-reliable-fetch'
require_relative 'worker'
require_relative 'no_retry_worker'

TEST_CLEANUP_INTERVAL = 20
TEST_LEASE_INTERVAL = 5

Sidekiq.configure_server do |config|
  config.options[:semi_reliable_fetch] = true

  # We need to override these parameters to not wait too long
  # The default values are good for production use only
  # These will be ignored for :basic
  config.options[:cleanup_interval] = TEST_CLEANUP_INTERVAL
  config.options[:lease_interval] = TEST_LEASE_INTERVAL

  Sidekiq::ReliableFetch.setup_reliable_fetch!(config)
end