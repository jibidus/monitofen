require 'rails_helper'

RSpec.describe "Measures", type: :request do
  describe "GET index" do
    let(:metric) { Metric.take }
    let(:from) { DateTime.now }
    let(:to) { from + 1.day }
    let(:measures) { [] }

    before do
      measures
      get(metric_measures_path(metric), xhr: true, params: { from: from.to_s, to: to.to_s })
    end

    context "when no measure" do
      let(:measures) { [] }

      it { expect(response).to be_json }
      it { expect(response).to have_http_status(:ok) }
      it { expect(json_response).to be_empty }
    end

    context "when one measure in requested time period" do
      let(:measure) { create(:measure, { metric.column_name => 1.2, date: from }) }
      let(:measures) { [measure] }

      it { expect(json_response).not_to be_empty }
      it { expect(json_response.size).to eq(1) }
      it { expect(json_response[0]['date']).to eq(measure.date.as_json) }
      it { expect(json_response[0]['value']).to eq(1.2) }
    end

    context "when measures not in requested time period" do
      let(:measures) do
        [
          create(:measure, { date: from - 1.hour }),
          create(:measure, { date: to }),
          create(:measure, { date: to + 1.hour })
        ]
      end

      it { expect(json_response).to be_empty }
    end

    context "when measures in requested time period" do
      let(:measure) { create(:measure, { date: from + 2.hours }) }
      let(:measures) { [measure] }

      it { expect(json_response).not_to be_empty }
    end

    context "when measure on the lower bound of the time period" do
      let(:measure) { create(:measure, { date: from }) }
      let(:measures) { [measure] }

      it { expect(json_response).not_to be_empty }
    end

    context "when measure on to upper bound of the time period" do
      let(:to_measure) { create(:measure, { date: to }) }
      let(:measures) { [to_measure] }

      it { expect(json_response).to be_empty }
    end

    context "when many measures in time period" do
      let(:measures) do
        [
          create(:measure, { date: from + 3.hours }),
          create(:measure, { date: from + 1.hour }),
          create(:measure, { date: from + 2.hours })
        ]
      end

      it { expect(json_response.map { |json| json['id'] }).to eq([measures[1].id, measures[2].id, measures[0].id]) }
    end

    context "when too many measures in requested time period" do
      let(:measures) do
        [
          create(:measure, { date: from + 1.hour }),
          create(:measure, { date: from + 2.hours }),
          create(:measure, { date: from + 3.hours })
        ]
      end

      around do |example|
        original = Rails.configuration.max_returned_measures
        Rails.configuration.max_returned_measures = 2
        example.run
        Rails.configuration.max_returned_measures = original
      end

      it { expect(json_response).to have_exactly(2).items }
    end
  end
end
