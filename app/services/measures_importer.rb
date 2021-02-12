require 'nokogumbo'
require 'uri'
require 'set'

class MeasuresImporter
  def initialize(boiler_base_url)
    @boiler = Boiler.new(boiler_base_url)
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
    Rails.logger.info "#{count} measure(s) imported in #{Time.current - start}s"
  end
end
