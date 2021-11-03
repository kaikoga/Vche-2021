# Vche-rails

Vche implementation in Ruby on Rails.
This application is intended to be runned in Docker.

## Development

Use Docker Compose. Everything is hard coded but at least it will work.

## Architecture

### Core Designs

- Old style Web application (Not-SPA)
- Semantic CSS with SCSS
- Banken

### Intentional Derailments

- Enumerize over AR::Enum
  - to preserve enum meanings without Rails, opening possibility for microservice
- Environment variables over credentials
  - because we use Docker + k8s
- `ApplicationController::Bootstrap` over `ApplicationController` 
  - to ease full design renewal
- Presenter as complex view models
  - "Complex" means "Equally concerning multiple records" 
- Operations for complex updates
  - Avoid but don't fear Anemic Domain Models
- `concerning :Model` within Banken loyalties
  - I know this is really ugly
 
### Flavor Preferences

- Sorcery over Devise + Omniauth
- Slim over Haml
- Vche.env over Rails.application.config.x.vche_env

### I was too lazy to

- Draper::Decorator over helpers
- Minitest - RuboCop - Brakeman
- Do any admin thing outside ActiveAdmin
