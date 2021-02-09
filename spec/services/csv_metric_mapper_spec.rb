require 'rails_helper'

RSpec.describe CsvMetricMapper do
  describe '.find' do
    subject { described_class.new.find(column_name) }

    let(:column_name) { 'AT [°C]' }
    let(:external_temperature) { Metric.find_by(label: 'T extérieure') }

    it { is_expected.to eq(external_temperature) }

    describe 'when unknown column' do
      let(:column_name) { 'Unknown' }

      it { is_expected.to be_nil }
    end

    describe 'when metric does not exist' do
      before { external_temperature.destroy! }

      # rubocop:disable RSpec/NamedSubject
      it { expect { subject }.to raise_exception(ActiveRecord::RecordNotFound) }
      # rubocop:enable RSpec/NamedSubject
    end
  end
end
