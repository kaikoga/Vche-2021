namespace :docker do
  namespace :development do
    desc 'Build Docker image vche-rails-dev and others'
    task :build do
      # I am lazy
      sh 'docker-compose build'
    end
  end
  namespace :production do
    desc 'Build Docker image vche-rails and others'
    task :build do
      # I am extremely lazy
      sh 'docker-compose -f docker-compose.production.yml build'
    end
  end
  desc 'Build all Docker images'
  task :build => ['docker:development:build', 'docker:production:build']
end
