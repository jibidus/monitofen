require 'rails_helper'

RSpec.describe "Metrics", type: :request do
  before { get '/metrics' }

  it { expect(response).to be_json }
  it { expect(response).to have_http_status(:ok) }
  it { expect(json_response).not_to be_empty }
  it { expect(json_response.size).to eq(Metric.count) }
end
