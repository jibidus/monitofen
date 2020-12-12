require 'rails_helper'

BOILER_URL = 'http://192.168.1.23:8080'

RSpec.describe 'measures:fetch', type: :task do
  context 'when no parameter provided' do
    it 'fails' do
      expect{ task.execute }.to raise_error(Rake::TaskArgumentError)
    end
  end

  context 'when no measure file is available' do
    before(:each) do
      html = BoilerResponse.build_files_index([])
      stub_request(:get, "#{BOILER_URL}/logfiles/pelletronic/")
      .to_return(body: html)

      task.execute from: BOILER_URL
    end

    it 'imports nothing' do
      expect(ImportedFile.count).to eq(0)
      expect(Measure.count).to eq(0)
    end
  end

  context 'when measure files are available' do
    before(:each) do
      html = BoilerResponse.build_files_index(['touch_20201208.csv'])
      stub_request(:get, "#{BOILER_URL}/logfiles/pelletronic/")
      .to_return(body: html)

      csv = <<-CSV
Datum ;Zeit ;AT [°C];KT Ist [°C];
10.12.2020;00:03:24;2,4;39,6;
10.12.2020;00:04:24;2,4;39,6;
CSV
      stub_request(:get, "#{BOILER_URL}/logfiles/pelletronic/touch_20201208.csv")
      .to_return(body: csv)

      task.execute from: BOILER_URL
    end

    it 'imports it' do
      expect(ImportedFile.count).to eq(1)
    end

    it 'creates metrics' do
      expect(Metric.pluck(:name)).to match_array(['AT [°C]', 'KT Ist [°C]'])
    end

    it 'creates measures' do
      measures = ImportedFile.take.measures
      expect(measures.count).to eq(4)

      date = DateTime.new(2020,12,10,0,3,24)
      metric = Metric.find_by!(name: 'KT Ist [°C]')
      measure = measures.where(date: date, metric: metric).take
      expect(measure).to_not be_nil
      expect(measure.value).to eq(39.6)
    end
  end
end
