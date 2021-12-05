namespace :docker do
  namespace :development do
    desc 'Build Docker image vche-rails-dev and others'
    task build: :environment do
      # sh 'docker-compose build'
      sh "docker build -f Dockerfile-dev -t kaikoga/vche-rails-dev:#{Vche.version} -t kaikoga/vche-rails-dev:latest ."
    end
  end
  namespace :production do
    desc 'Build Docker image vche-rails and others'
    task build: :environment do
      # sh 'docker-compose -f docker-compose.production.yml build'
      sh "docker build -t kaikoga/vche-rails:#{Vche.version} -t kaikoga/vche-rails:latest ."
      sh "docker build -t kaikoga/vche-nginx:#{Vche.version} -t kaikoga/vche-nginx:latest dockerfiles/vche-nginx"
      sh "docker push kaikoga/vche-rails:#{Vche.version}"
      sh "docker push kaikoga/vche-nginx:#{Vche.version}"
    end
  end
  desc 'Build all Docker images'
  task :build => ['docker:development:build', 'docker:production:build']
end
