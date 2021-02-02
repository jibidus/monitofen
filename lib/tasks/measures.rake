# frozen_string_literal: true

namespace :measures do
  desc "Fetch new measures from boiler and store it in database"
  task :fetch, [:from] => [:environment] do |_, args|
    boiler_base_url = args[:from] || ENV['MONITOFEN_BOILER_BASE_URL']

    # rubocop:disable Style/RaiseArgs
    raise Rake::TaskArgumentError.new('Mandatory environment variable "MONITOFEN_BOILER_BASE_URL" not defined') if boiler_base_url.blank?

    MeasuresImporter.new(boiler_base_url).import_all
    Rails.logger.info "job finished."
  end
end
