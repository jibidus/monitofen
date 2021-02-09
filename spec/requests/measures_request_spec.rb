require 'rails_helper'

RSpec.describe "Measures", type: :request do
  describe "when no measure" do
    before { get '/measures' }

    it { expect(response).to be_json }
    it { expect(response).to have_http_status(:ok) }
    it { expect(json_response).to be_empty }
  end

  describe "when some measures" do
    before do
      create :measure, metric_1: 1.2 # rubocop:disable Naming/VariableNumber
      get '/measures'
    end

    it { expect(json_response).not_to be_empty }
    it { expect(json_response.size).to eq(1) }
    it { expect(json_response[0]['metric_1']).to eq(1.2) }
  end
end
