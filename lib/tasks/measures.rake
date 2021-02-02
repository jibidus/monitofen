# frozen_string_literal: true

namespace :measures do
  desc "Fetch new measures from boiler and store it in database"
  task :fetch, [:from] => [:environment] do |_, args|
    from = args[:from]
    # rubocop:disable Style/RaiseArgs
    raise Rake::TaskArgumentError.new('No "from" parameter provided') if from.blank?

    MeasuresImporter.new(from).import_all
    Rails.logger.info "job finished."
  end
end
