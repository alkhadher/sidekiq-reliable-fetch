# frozen_string_literal: true

require 'sidekiq'
require_relative 'config'
require_relative '../support/utils'

NUM_WORKERS = RetryTestWorker::EXPECTED_NUM_TIMES_BEEN_RUN + 1

Sidekiq.redis(&:flushdb)

pids = spawn_workers(NUM_WORKERS)

jid = RetryTestWorker.perform_async

sleep 300

Sidekiq.redis do |redis|
  times_has_been_run = redis.get('times_has_been_run').to_i
  assert 'The job has been run', times_has_been_run, RetryTestWorker::EXPECTED_NUM_TIMES_BEEN_RUN
end

assert 'Found dead jobs', Sidekiq::DeadSet.new.size, 1

stop_workers(pids)