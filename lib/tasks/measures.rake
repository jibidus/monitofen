# frozen_string_literal: true

namespace :measures do
  desc "Fetch new measures from boiler and store it in database"
  task :fetch, [:from] => [:environment] do |_, args|
    MeasuresImporter.new(args[:from]).import_all
    Rails.logger.info "job finished."
  end
end
