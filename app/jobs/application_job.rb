class ApplicationJob < ActiveJob::Base
  include Slack::Slackable

  class NotYetAnalyzedError < StandardError; end
  retry_on NotYetAnalyzedError, attempts: 15, wait: :exponentially_longer

  # Automatically retry jobs that encountered a deadlock
  retry_on ActiveRecord::Deadlocked, attempts: 15, wait: :exponentially_longer

  # Most jobs are safe to ignore if the underlying records are no longer available
  discard_on ActiveJob::DeserializationError

  queue_as :default
end
