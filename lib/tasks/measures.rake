namespace :measures do
  desc "Import new measures from boiler and store it in database"
  task :import, [:from] => [:environment] do |_, args|
    boiler_base_url = args[:from] || ENV['MONITOFEN_BOILER_BASE_URL']

    if boiler_base_url.blank?
      raise Rake::TaskArgumentError.new('Mandatory environment variable "MONITOFEN_BOILER_BASE_URL" not defined') # rubocop:disable Style/RaiseArgs
    end

    MeasuresImporter.new(boiler_base_url).import_all
    Rails.logger.info "job finished."
  end
end
