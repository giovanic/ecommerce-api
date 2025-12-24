source "https://rubygems.org"
ruby "3.3.4"

# Core
gem "rails", "~> 8.0.4"
gem "pg", "~> 1.5"
gem "puma", ">= 5.0"

# Deploy
gem "kamal", require: false

# Add HTTP
gem "thruster", require: false

# API
gem "rack-cors"

# Trailblazer
gem "trailblazer-rails", "~> 2.4"
gem "reform", "~> 2.6"
gem "reform-rails"
gem "dry-validation", "~> 1.10"
gem "dry-monads", "~> 1.6"
gem "representable", "~> 3.2"

# Authentication
gem "rodauth-rails", "~> 2.1"
gem "jwt"
gem "bcrypt", "~> 3.1.7"

# Background Jobs
gem "solid_queue"
# gem "mission_control-jobs" # Incompatível com Rails 8 API-only
gem "solid_cache"

# Payments
gem "stripe", "~> 10.0"
gem "mercadopago-sdk", "~> 2.2"

# File Upload
gem "cloudinary", "~> 2.4"
gem "activestorage", "~> 8.0"

# Search
gem "meilisearch-rails", "~> 0.11"

# Utilities
gem "money-rails", "~> 1.15"
gem "friendly_id", "~> 5.5"
gem "kaminari", "~> 1.2"
gem "paranoia", "~> 3.0"
gem "aasm", "~> 5.5"

# Performance
gem "bootsnap", require: false
gem "oj"

# Timezone
gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby]

group :development, :test do
  gem "debug"
  gem "rspec-rails", "~> 6.1"
  gem "factory_bot_rails", "~> 6.4"
  gem "faker", "~> 3.2"
  gem "shoulda-matchers", "~> 6.0"
  gem "database_cleaner-active_record"
  gem "dotenv-rails"
end

group :development do
  gem "annotate"
  gem "bullet"
  gem "rubocop-rails", require: false
  gem "rubocop-rspec", require: false
  gem "rubocop-performance", require: false
  gem "letter_opener"
end

group :test do
  gem "simplecov", require: false
  gem "webmock"
  gem "vcr"
end
