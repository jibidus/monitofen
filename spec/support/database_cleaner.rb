require 'database_cleaner/active_record'

RSpec.configure do |config|
  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with :truncation, { except: %w[metrics ar_internal_metadata] }
    Rails.application.load_seed
  end

  config.around do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end
end
