#!/usr/bin/ruby
# frozen_string_literal: true

ENVIRONMENT_TASKS = {
  'review' => ['bundle exec rails db:migrate', 'bundle exec rails db:seed'],
  'production' => ['bundle exec rails db:migrate']
}.freeze

def environment
  @environment ||= begin
    rails_env = ENV['RAILS_ENV'] || ''
    rake_env = ENV['RAKE_ENV'] || ''
    return rails_env if !rails_env.empty? && ENVIRONMENT_TASKS.keys.include?(rails_env)
    return rake_env if !rake_env.empty? && ENVIRONMENT_TASKS.keys.include?(rails_env)

    raise "RAILS_ENV or RAKE_ENV must be set as an environment variable. Possible values are: #{ENVIRONMENT_TASKS.keys}"
  end
end

# release logic
tasks = ENVIRONMENT_TASKS[environment]
puts "Tasks to run on release:"
tasks.each_with_index do |task, index|
  puts "[#{index}] #{task}"
end
tasks.each do |task|
  scoped_task = "RAILS_ENV=#{environment} task"
  puts "==== Executing: #{task} ===="
  puts %x[#{task}]
  puts "===== Finished ====="
end
