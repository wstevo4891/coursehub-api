source "https://rubygems.org"

ruby "3.3.1"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 7.1.3"

# Use the Puma web server [https://github.com/puma/puma]
gem "puma", ">= 5.0"

# Use postgresql as the database for Active Record
gem "pg", "~> 1.1"

# Use Mongoid as the Object-Document Mapper (ODM) for MongoDB
gem "mongoid"

# Use Redis adapter to run Action Cable in production
gem "redis", ">= 4.0.1"

# Use hiredis connection library for better performance with Redis.
gem "hiredis"

# Use connection_pool < 3 to avoid bug with ActiveSupport::RedisCacheStore.
gem "connection_pool", "<3"

# Background job processing
gem "sidekiq"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ windows jruby ]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

# Use JWT for generating JSON Web Tokens
gem "jwt"

# Use Pundit for authorization policies
gem "pundit"

# Use Active Model Serializers to serialize model data into JSON responses
gem "active_model_serializers"

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
# gem "jbuilder"

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin Ajax possible
gem "rack-cors"

# Use rate limiting to protect against DOS attacks and other abuse.
gem "rack-attack"

# Configure security headers
gem "secure_headers"

# Use AWS S3 for file storage
gem "aws-sdk-s3", require: false

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[ mri windows ]

  # Omakase Ruby styling [https://github.com/rails/rubocop-rails-omakase/]
  gem "rubocop-rails-omakase", require: false

  # Use Faker to generate data
  gem "faker"

  # Use rswag to generate documentation
  gem "rswag-api"
  gem "rswag-ui"
  gem "rswag-specs"

  # Use RSpec for testing
  gem "rspec-rails"

  # Use shoulda-matchers to add testing methods
  gem "shoulda-matchers"

  # Use Factory Bot to generate test data
  gem "factory_bot_rails"

  # Use Database Cleaner to clean data between test runs
  gem "database_cleaner-active_record"
end

group :development do
  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"
end

group :test do
  # Use SimpleCov for test coverage reporting
  gem "simplecov", require: false
end
