require "rails_helper"

RSpec.describe ImportationMailer, type: :mailer do
  describe "send_importation_report" do
    let(:mail) { described_class.send_importation_report(importation) }

    context "when importation is successful" do
      let(:importation) { create(:importation, :successful, file_name: "touch_20200427.csv") }

      it { expect(mail.body.encoded).to include("File touch_20200427.csv was imported successfully") }
      it { expect(mail.subject).to eq("Importation of file touch_20200427.csv") }
    end

    context "when importation failed" do
      let(:importation) { create(:importation, :failed, file_name: "touch_20200427.csv") }

      it { expect(mail.body.encoded).to include("File touch_20200427.csv failed to be imported") }
      it { expect(mail.subject).to eq("Importation of file touch_20200427.csv") }
    end
  end
end
