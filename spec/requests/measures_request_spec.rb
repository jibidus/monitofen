require 'rails_helper'

RSpec.describe "Measures", type: :request do
  describe "when no measure" do
    let(:metric) { Metric.take }

    before { get "/metrics/#{metric.id}/measures" }

    it { expect(response).to be_json }
    it { expect(response).to have_http_status(:ok) }
    it { expect(json_response).to be_empty }
  end

  describe "when some measures" do
    let(:metric) { Metric.take }
    let(:measure_date) { Time.zone.now }

    before do
      create :measure, { metric.column_name => 1.2, date: measure_date }
      get "/metrics/#{metric.id}/measures"
    end

    it { expect(json_response).not_to be_empty }
    it { expect(json_response.size).to eq(1) }
    it { expect(json_response[0]['date']).to eq(measure_date.as_json) }
    it { expect(json_response[0]['value']).to eq(1.2) }
  end
end
