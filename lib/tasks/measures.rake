namespace :measures do
  desc "Import new measures from boiler and store it in database. Parameter is boiler base url or file path."
  task :import, [:from] => [:environment] do |_, args|
    base_url_or_file_path = args[:from] || ENV['MONITOFEN_BOILER_BASE_URL']

    if base_url_or_file_path.blank?
      raise Rake::TaskArgumentError.new('Mandatory environment variable "MONITOFEN_BOILER_BASE_URL" not defined') # rubocop:disable Style/RaiseArgs
    end

    result = MeasuresImporter.new(base_url_or_file_path).import_all
    Rails.logger.info "#{result.successful_importations}/#{result.all_importations} files imported successfully"
    result.raise_error_if_any
  end
end
