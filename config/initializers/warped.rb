# frozen_string_literal: true

Warped.configure do |config|
  # Change the parent class of Warped::Job::Base.
  # This is useful if you want to use a different ActiveJob parent class.
  # Default: 'ActiveJob::Base'
  config.base_job_parent_class = 'ApplicationJob'
end
