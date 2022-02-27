require 'rails_helper'

RSpec.describe "Measurements", type: :request do
  describe "GET index" do
    let(:metric) { Metric.take }
    let(:from) { DateTime.now }
    let(:to) { from + 1.day }
    let(:measurements) { [] }

    before do
      measurements
      get(metric_measurements_path(metric), xhr: true, params: { from: from.to_s, to: to.to_s })
    end

    context "when no measurement" do
      let(:measurements) { [] }

      it { expect(response).to be_json }
      it { expect(response).to have_http_status(:ok) }
      it { expect(json_response).to be_empty }
    end

    context "when one measurement in requested time period" do
      let(:measurement) { create(:measurement, { metric.column_name => 1.2, date: from }) }
      let(:measurements) { [measurement] }

      it { expect(json_response).not_to be_empty }
      it { expect(json_response.size).to eq(1) }
      it { expect(json_response[0]['date']).to eq(measurement.date.as_json) }
      it { expect(json_response[0]['value']).to eq(1.2) }
    end

    context "when measurements not in requested time period" do
      let(:measurements) do
        [
          create(:measurement, { date: from - 1.hour }),
          create(:measurement, { date: to }),
          create(:measurement, { date: to + 1.hour })
        ]
      end

      it { expect(json_response).to be_empty }
    end

    context "when measurements in requested time period" do
      let(:measurement) { create(:measurement, { date: from + 2.hours }) }
      let(:measurements) { [measurement] }

      it { expect(json_response).not_to be_empty }
    end

    context "when measurement on the lower bound of the time period" do
      let(:measurement) { create(:measurement, { date: from }) }
      let(:measurements) { [measurement] }

      it { expect(json_response).not_to be_empty }
    end

    context "when measurement on to upper bound of the time period" do
      let(:to_measurement) { create(:measurement, { date: to }) }
      let(:measurements) { [to_measurement] }

      it { expect(json_response).to be_empty }
    end

    context "when many measurements in time period" do
      let(:measurements) do
        [
          create(:measurement, { date: from + 3.hours }),
          create(:measurement, { date: from + 1.hour }),
          create(:measurement, { date: from + 2.hours })
        ]
      end

      it {
        expect(json_response.map do |json|
                 json['id']
               end).to eq([measurements[1].id, measurements[2].id, measurements[0].id])
      }
    end

    context "when too many measurements in requested time period" do
      let(:measurements) do
        [
          create(:measurement, { date: from + 1.hour }),
          create(:measurement, { date: from + 2.hours }),
          create(:measurement, { date: from + 3.hours })
        ]
      end

      around do |example|
        original = Rails.configuration.max_returned_measurements
        Rails.configuration.max_returned_measurements = 2
        example.run
        Rails.configuration.max_returned_measurements = original
      end

      it { expect(json_response).to have_exactly(2).items }
    end
  end
end
