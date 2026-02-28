# config/initializers/sidekiq_cron.rb
if defined?(Sidekiq) && Sidekiq.server?
  require "sidekiq/cron/job"
  cfg = YAML.load_file(Rails.root.join("config/sidekiq.yml"))
  Sidekiq::Cron::Job.load_from_hash(cfg[":schedule"]) if cfg && cfg[":schedule"]
end
