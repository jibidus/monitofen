require 'nokogumbo'
require 'uri'
require 'set'

class MeasuresImporter
  def initialize(boiler_base_url_or_file_path)
    @boiler = Boiler.new(boiler_base_url_or_file_path)
  end

  def import_all
    files = @boiler.files
    Rails.logger.info "#{files.count} measure file(s) found"
    files.select(&:measures?)
         .select(&:complete?)
         .reject(&:imported?)
         .each do |file|
      Importation.import(file.name) do |importation|
        import!(file, importation)
      end
    end
  end

  private

  def import!(file, importation)
    Rails.logger.info "Import file #{file.name}…"
    start = Time.current
    count = ApplicationRecord.transaction do
      file.csv_content.import! do |measure|
        measure.importation = importation
      end
    end
    Rails.logger.info <<~MSG
      File \"#{file.name}\" successfully imported with #{count} measure(s) in #{Time.current - start}s.
    MSG
  end
end
