require 'rails_helper'

RSpec.describe "Measures", type: :request do
  let(:metric) { Metric.take }
  let(:from) { DateTime.now }
  let(:to) { from + 1.day }

  describe "when no measure" do
    before { get(metric_measures_path(metric), xhr: true, params: { from: from.to_s, to: to.to_s }) }

    it { expect(response).to be_json }
    it { expect(response).to have_http_status(:ok) }
    it { expect(json_response).to be_empty }
  end

  describe "when one measure in requested time period" do
    let!(:measure) { create(:measure, { metric.column_name => 1.2, date: from }) }

    before { get(metric_measures_path(metric), xhr: true, params: { from: from.to_s, to: to.to_s }) }

    it { expect(json_response).not_to be_empty }
    it { expect(json_response.size).to eq(1) }
    it { expect(json_response[0]['date']).to eq(measure.date.as_json) }
    it { expect(json_response[0]['value']).to eq(1.2) }
  end

  describe "when measures not in requested time period" do
    before do
      create :measure, { date: from - 1.hour }
      create :measure, { date: to }
      create :measure, { date: to + 1.hour }
      get metric_measures_path(metric), xhr: true, params: { from: from.to_s, to: to.to_s }
    end

    it { expect(json_response).to be_empty }
  end

  describe "when measures in requested time period" do
    let!(:from_measure) { create(:measure, { date: from }) }
    let!(:in_measure) { create(:measure, { date: from + 2.hours }) }
    let!(:to_measure) { create(:measure, { date: to }) }

    before { get(metric_measures_path(metric), xhr: true, params: { from: from.to_s, to: to.to_s }) }

    it { expect(json_response).not_to be_empty }
    it { expect(json_response.map { |json| json['id'] }).to include(from_measure.id, in_measure.id) }
    it { expect(json_response.map { |json| json['id'] }).not_to include(to_measure.id) }
  end

  describe "order" do
    let!(:measure3) {create(:measure, { date: from + 3.hours })}
    let!(:measure1) {create(:measure, { date: from + 1.hour })}
    let!(:measure2) {create(:measure, { date: from + 2.hours })}

    before { get(metric_measures_path(metric), xhr: true, params: { from: from.to_s, to: to.to_s }) }

    it { expect(json_response.map { |json| json['id'] }).to eq([measure1.id, measure2.id, measure3.id]) }
  end

  context "when too many measures in requested time period" do
    before do
      @original_max_returned_measures = Rails.configuration.max_returned_measures
      Rails.configuration.max_returned_measures = 2

      create(:measure, { date: from + 1.hour })
      create(:measure, { date: from + 2.hours })
      create(:measure, { date: from + 3.hours })
      get(metric_measures_path(metric), xhr: true, params: { from: from.to_s, to: to.to_s })
    end

    after { Rails.configuration.max_returned_measures = @original_max_returned_measures }

    it { expect(json_response).not_to be_empty }
    it { expect(json_response).to have_exactly(2).items }
  end
end
