SKIP_RULES = {
  "not complete" => ->(file) { file.incomplete? },
  "already imported" => ->(file) { file.already_imported? }
}.freeze

class ImportationBatch
  def initialize(files)
    @all_files = files
    @skipped_files = []
    @success_files = []
    @failed_files = []
  end

  def run!
    @all_files.each do |file|
      next unless skip_if_not_importable(file)

      import! file
    end
    Rails.logger.info stats_summary
    raise ImportationError, @failed_files if @failed_files.any?
  end

  private

  def import!(file)
    importation = Importation.execute(file.name) do |imp|
      file.import! imp
    end
    importation.successful? ? add_successful(file) : add_failed(file)
  end

  def skip_if_not_importable(file)
    SKIP_RULES.each do |reason, skip_predicate|
      if skip_predicate.call(file)
        add_skipped file, reason
        return false
      end
    end
    true
  end

  def add_successful(file)
    @success_files << file
  end

  def add_failed(file)
    @failed_files << file
  end

  def add_skipped(file, reason)
    Rails.logger.info "File \"#{file.name}\" skipped (#{reason})"
    @skipped_files << file
  end

  def stats_summary
    total = @success_files.size + @failed_files.size
    output = "#{@success_files.size}/#{total} file(s) imported successfully."
    output << "\n#{@failed_files.size} in error." if @failed_files.any?
    output << "\n#{@skipped_files.size} skipped." if @skipped_files.any?
    output
  end
end

class ImportationError < StandardError
  def initialize(failed_files)
    @count = failed_files.size
    super
  end

  def message
    "#{@count} importation(s) failed"
  end
end
