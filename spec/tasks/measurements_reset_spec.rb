require 'rails_helper'
require 'csv_metric_mapper'
require 'tempfile'

RSpec.describe 'measurements:reset', type: :task do
  before do
    allow(Rails.logger).to receive(:info)
    create :importation
    create :measurement
    task.execute
  end

  it { expect(Importation.count).to eq(0) }
  it { expect(Measurement.count).to eq(0) }
  it { expect(Rails.logger).to have_received(:info).with(/1 measurement\(s\) deleted/).once }
end
