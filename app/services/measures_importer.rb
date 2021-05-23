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
    importations = []
    files.select(&:measures?)
         .select(&:complete?)
         .reject(&:imported?)
         .each do |file|
      importations << Importation.import(file.name) { |imp| import!(file, imp) }
    end
    ImportationResult.new importations
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

class ImportationResult
  attr_reader :files_in_error

  def initialize(importations)
    @files_in_error = importations.filter(&:failed?).size
  end

  def raise_error_if_any
    raise ImportationError, @files_in_error if @files_in_error.positive?
  end
end

class ImportationError < StandardError
  def initialize(count)
    @count = count
    super()
  end

  def message
    "#{@count} importation failed"
  end
end
