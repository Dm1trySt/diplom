namespace :project do
  namespace :crontab do

    SCHEDULE_FILE = 'plugins/instruments/config/schedule.rb'

    desc "Generate crontab from #{SCHEDULE_FILE}"
    task :show => :environment do
      require 'whenever'
      Whenever::CommandLine.execute(file: SCHEDULE_FILE)
    end

    desc "Update crontab from #{SCHEDULE_FILE}"
    task :update => :environment do
      require 'whenever'
      Whenever::CommandLine.execute(file: SCHEDULE_FILE, write: true)
    end

  end
end
