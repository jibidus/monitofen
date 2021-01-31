# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Metric do
  describe '::all_by_csv_column' do
    subject { Metric.all_by_csv_column }
    let(:external_temperature) { Metric.find_by(label: 'T extérieure') }
    it { expect(subject).to include('AT [°C]' => external_temperature) }
  end
end
