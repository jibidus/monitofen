require 'nokogumbo'
require 'uri'
require 'set'

class MeasuresImporter
  def initialize(boiler_base_url_or_file_path)
    @boiler = Boiler.new(boiler_base_url_or_file_path)
    @stats = ImportStats.new
  end

  def import_all
    files_to_import do |file|
      importation = Importation.import(file.name) { |imp| import!(file, imp) }
      @stats.importations << importation
    end
    @stats
  end

  private

  SKIP_RULES = {
    "not complete" => ->(file) { file.incomplete? },
    "already imported" => ->(file) { file.already_imported? }
  }.freeze

  def files_to_import
    @boiler.measures_files.each do |file|
      break unless SKIP_RULES.each do |reason, predicate|
        if predicate.call(file)
          @stats.skip file.name, reason
          break
        end
      end

      yield file
    end
  end

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

class ImportStats
  attr_accessor :importations

  def initialize
    @importations = []
    @skipped_files = []
  end

  def skip(file_name, reason)
    Rails.logger.info "File \"#{file_name}\" skipped (#{reason})"
    @skipped_files << file_name
  end

  def total
    @importations.size
  end

  def successful
    @importations.count(&:successful?)
  end

  def failed
    @importations.size - successful
  end

  def skipped
    @skipped_files.size
  end

  def raise_error_if_any
    raise ImportationError, failed if failed.positive?
  end

  def log
    output = "#{successful}/#{total} files imported successfully."
    output << "\n#{failed} in error." if failed.positive?
    output << "\n#{skipped} skipped." if skipped.positive?
    Rails.logger.info output
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
