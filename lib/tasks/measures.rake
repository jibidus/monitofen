namespace :measures do
  desc "Fetch new measures from boiler and store it in database"
  task :fetch, [:from] => [:environment] do |task, args|
    from = args[:from]
    if from.nil? || from.empty?
      raise Rake::TaskArgumentError.new('No "from" parameter provided')
    end
    MeasuresImporter.new(from).import_all
    Rails.logger.info "job finished."
  end
end
