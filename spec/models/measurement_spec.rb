require 'rails_helper'

RSpec.describe Measurement, type: :model do
  describe "::taken" do
    let!(:measurement) { create :measurement, date: Time.zone.local(2020, 12, 10, 0, 3, 24) }

    it { expect(described_class.taken(Date.new(2020, 12, 10)).to_a).to include(measurement) }
    it { expect(described_class.taken(Date.new(2020, 12, 11)).to_a).not_to include(measurement) }
  end
end
