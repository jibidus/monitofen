class Importation < ApplicationRecord
  validates :file_name, :status, presence: true
  has_many :measures, dependent: :destroy
  validates :status, inclusion: { in: %i[running successful failed] }

  def status
    self[:status].try(:to_sym)
  end

  def status=(value)
    self[:status] = value.to_s
  end

  def successful?
    status == :successful
  end

  def failed?
    status == :failed
  end

  def running?
    status == :running
  end

  def self.import(file_name)
    importation = Importation.create!(file_name: file_name, status: :running)
    begin
      yield importation
      importation.update! status: :successful
    rescue StandardError => e
      Rails.logger.error e.message
      importation.update! status: :failed
    end
    ImportationMailer.send_importation_report(importation).deliver
    importation
  end
end
