namespace :measurements do
  desc "Import new measurements from boiler and store it in database. Parameter is boiler base url or file path."
  task :import, [:from] => [:environment] do |_, args|
    base_url_or_file_path = args[:from] || ENV.fetch('MONITOFEN_BOILER_BASE_URL', nil)

    if base_url_or_file_path.blank?
      raise Rake::TaskArgumentError.new('Mandatory environment variable "MONITOFEN_BOILER_BASE_URL" not defined') # rubocop:disable Style/RaiseArgs
    end

    boiler = Boiler.new(base_url_or_file_path)
    ImportationBatch.new(boiler.measurements_files).run!
  end

  desc "Delete all measurements"
  task :reset, [:from] => [:environment] do |_, _|
    count = Measurement.count
    Importation.destroy_all
    Rails.logger.info "#{count} measurement(s) deleted"
  end
end
