SKIP_RULES = {
  "not complete" => ->(file) { file.incomplete? },
  "already imported" => ->(file) { file.already_imported? }
}.freeze

class ImportationBatch
  def initialize(files)
    @all = files
    @skipped = []
    @success = []
    @failed = []
  end

  def run!
    @all.each do |file|
      break unless skip_if_not_importable(file)

      importation = Importation.execute(file.name) do |imp|
        file.import! imp
      end
      importation.successful? ? success(file) : failed(file)
    end
    Rails.logger.info stats_summary
    raise ImportationError, @failed if @failed.any?
  end

  private

  def skip_if_not_importable(file)
    SKIP_RULES.each do |reason, skip_predicate|
      if skip_predicate.call(file)
        skip file, reason
        return false
      end
    end
    true
  end

  def success(file)
    @success << file
  end

  def failed(file)
    @failed << file
  end

  def skip(file, reason)
    Rails.logger.info "File \"#{file.name}\" skipped (#{reason})"
    @skipped << file
  end

  def stats_summary
    total = @success.size + @failed.size
    output = "#{@success.size}/#{total} file(s) imported successfully."
    output << "\n#{@failed.size} in error." if @failed.any?
    output << "\n#{@skipped.size} skipped." if @skipped.any?
    output
  end
end

class ImportationError < StandardError
  def initialize(failed_files)
    @count = failed_files.size
    super()
  end

  def message
    "#{@count} importation(s) failed"
  end
end
