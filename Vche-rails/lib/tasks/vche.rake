namespace :vche do
  namespace :daily do
    desc 'Run all daily tasks'
    task all: 'vche:daily:report'

    desc 'Output daily report'
    task report: :environment do
      Operations::Daily::Report.new.perform!
    end
  end
end
