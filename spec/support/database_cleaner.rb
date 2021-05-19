require 'database_cleaner/active_record'

RSpec.configure do |config|
  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with :truncation, { except: %w[metrics ar_internal_metadata] }
    create_referential_data!
  end

  config.around do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end
end
