namespace :db do
  desc 'Validates all records in the database. Use variable EXCLUDED_MODELS to excluded some models (comma separated)'
  task validate: :environment do
    Rails.logger.info 'Validate database (this will take some time)...'
    excluded_models = (ENV['EXCLUDED_MODELS'] || '').split(',')
    Rails.logger.info "Excluded models: #{excluded_models}"
    ActiveRecord::Base.subclasses
                      .reject { |type| type.to_s.include? '::' } # subclassed classes are not our own models
                      .reject { |type| excluded_models.include? type.to_s }
                      .each do |type|
      Rails.logger.info "Checking #{type}..."
      type.unscoped.find_each do |record|
        unless record.valid?
          Rails.logger.error "#<#{type} id: #{record.id}, errors: #{record.errors.full_messages}>"
        end
      end
    end
  end
end
