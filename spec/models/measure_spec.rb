require 'rails_helper'

RSpec.describe Measure, type: :model do
  describe "::taken" do
    let!(:measure) { create :measure, date: Time.zone.local(2020, 12, 10, 0, 3, 24) }

    it { expect(described_class.taken(Date.new(2020, 12, 10)).to_a).to include(measure) }
    it { expect(described_class.taken(Date.new(2020, 12, 11)).to_a).not_to include(measure) }
  end
end
