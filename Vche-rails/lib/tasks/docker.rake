namespace :docker do
  namespace :development do
    desc 'Build Docker image vche-rails-dev and others'
    task build: :environment do
      # sh 'docker-compose build'
      sh "docker build -f Dockerfile-dev -t kaikoga/vche-rails-dev:#{Vche.version} ."
    end
  end
  namespace :production do
    desc 'Build Docker image vche-rails and others'
    task build: :environment do
      # sh 'docker-compose -f docker-compose.production.yml build'
      sh "docker build -t kaikoga/vche-rails:#{Vche.version} ."
      sh "docker build -t kaikoga/vche-nginx:#{Vche.version} dockerfiles/vche-nginx"
    end
  end
  desc 'Build all Docker images'
  task :build => ['docker:development:build', 'docker:production:build']
end
