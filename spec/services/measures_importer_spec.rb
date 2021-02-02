# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MeasuresImporter do
  describe '.metrics_by_csv_column' do
    subject(:metrics) { described_class.new("http://example.test").metrics_by_csv_column }

    let(:external_temperature) { Metric.find_by(label: 'T extérieure') }

    it { expect(metrics).to include('AT [°C]' => external_temperature) }
  end
end
