# frozen_string_literal: true

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
      bench { import!(file) }
    end
  end

  private

  def import!(file)
    Rails.logger.info "Import file #{file.name}…"
    ApplicationRecord.transaction do
      importation = Importation.create!(file_name: file.name)
      file.csv_content.import! do |measure|
        measure.importation = importation
      end
    end
  end

  def bench
    start = Time.current
    count = yield
    Rails.logger.info "#{count} measure(s) imported in #{Time.current - start}s"
  end
end
