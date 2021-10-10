# Vche-rails

Vche implementation in Ruby on Rails.
This application is intended to be runned in Docker.

## Architecture

### Core Designs

- Old style Web application (Not-SPA)
- Semantic CSS with SCSS
- Banken
- Operations

### Intentional Derailments

- Enumerize over AR::Enum
- Environment variables over credentials
  - because we use Docker

### Flavor Preferences

- Sorcery over Devise + Omniauth
- Slim over Haml
