require 'rails_helper'
require 'measures_importer'
require 'csv_metric_mapper'
require 'tempfile'

RSpec.describe 'measures:import', type: :task do
  before do
    allow(Rails.logger).to receive(:info)
    allow(Rails.logger).to receive(:warn)
    allow(Rails.logger).to receive(:error)
  end

  context 'when no parameter provided' do
    it { expect { task.execute }.to raise_error(Rake::TaskArgumentError) }
  end

  context 'when no file is available' do
    before do
      FakeBoiler.stub_files([])
      task.execute from: FakeBoiler.url
    end

    it { expect(Importation.count).to eq(0) }
    it { expect(Measure.count).to eq(0) }
  end

  context 'when file path given' do
    let(:file) do
      Tempfile.new(["touch_20201210", ".csv"]).tap do |f|
        f << <<~CSV
          Datum ;Zeit ;AT [°C];KT Ist [°C];
          10.12.2020;00:03:24;2,4;39,6;
          10.12.2020;00:04:24;2,4;39,6;
        CSV
        f.close
      end
    end

    after do
      file.unlink
    end

    before do
      task.execute from: file.path
    end

    it { expect(Importation.count).to eq(1) }
    it { expect(Rails.logger).to have_received(:info).with(/File "touch_20201210.*\.csv" successfully imported./).once }
  end

  context 'when files are available but not CSV' do
    before do
      FakeBoiler.stub_files(['graph_20201220.png'])
      task.execute from: FakeBoiler.url
    end

    it { expect(Importation.count).to eq(0) }
  end

  context 'when only titles.csv is available' do
    before do
      FakeBoiler.stub_files(['titles.csv'])
      task.execute from: FakeBoiler.url
    end

    it { expect(Importation.count).to eq(0) }
  end

  context 'when one measure file is available' do
    let(:measure_date) { Time.zone.local(2020, 12, 10, 0, 3, 24) }
    let(:file_name) { "touch_#{measure_date.strftime('%Y%m%d')}.csv" }

    before do
      FakeBoiler.stub_files([file_name])
      FakeBoiler.stub_file(file_name, <<~CSV)
        Datum ;Zeit ;AT [°C];KT Ist [°C];
        #{measure_date.strftime('%d.%m.%Y')};#{measure_date.strftime('%H:%M:%S')};2,4;39,6;
      CSV

      task.execute from: FakeBoiler.url
    end

    it { expect(Importation.count).to eq(1) }

    it { expect(Measure.count).to eq(1) }

    it 'creates measures with values from CSV' do
      measure = Measure.find_by!(date: measure_date)
      metric = Metric.find_by!(label: MAPPING['KT Ist [°C]'])
      value = measure.send(metric.column_name)
      expect(value).to eq(39.6)
    end

    it { expect(Rails.logger).to have_received(:info).with(/Import file #{file_name}/) }

    it {
      expected_log = /File "touch_20201210\.csv" successfully imported with 1 measure\(s\) in .*s\./
      expect(Rails.logger).to have_received(:info).with(expected_log)
    }

    it { expect(ActionMailer::Base.deliveries.count).to eq(1) }
  end

  context 'when measure file was already imported' do
    let(:file_name) { "touch_20210214.csv" }

    before do
      FakeBoiler.stub_files([file_name])
      create :importation, file_name: file_name
      task.execute from: FakeBoiler.url
    end

    it { expect(Importation.count).to eq(1) }
  end

  context 'when many measure files are available' do
    let(:file_name1) { 'touch_20201208.csv' }
    let(:file_name2) { 'touch_20201209.csv' }

    before do
      FakeBoiler.stub_files([file_name1, file_name2])
      FakeBoiler.stub_file(file_name1, <<~CSV)
        Datum ;Zeit ;AT [°C];KT Ist [°C];
        08.12.2020;00:03:24;2,4;39,6;
      CSV
      FakeBoiler.stub_file(file_name2, <<~CSV)
        Datum ;Zeit ;AT [°C];KT Ist [°C];
        09.12.2020;00:03:24;2,4;39,6;
      CSV

      task.execute from: FakeBoiler.url
    end

    it { expect(Importation.count).to eq(2) }
  end

  context 'when a measure files is available for today' do
    let(:file_name) { "touch_#{Time.zone.today.strftime('%Y%m%d')}.csv" }

    before do
      FakeBoiler.stub_files([file_name])
      task.execute from: FakeBoiler.url
    end

    it { expect(Importation.count).to eq(0) }
  end

  context 'when measure file already imported successfully' do
    let(:file_date) { DateTime.new(2020, 12, 8, 20, 10, 0) }
    let(:file_name) { "touch_#{file_date.strftime('%Y%m%d')}.csv" }
    let(:metric) { Metric.find_by!(label: MAPPING['AT [°C]']) }
    let(:importation) { create(:importation, :successful, file_name: file_name) }
    let(:measure) do
      Measure.create!(
        date: file_date,
        "#{metric.column_name}": 10,
        importation: importation
      )
    end

    before do
      measure
      FakeBoiler.stub_files([file_name])
      FakeBoiler.stub_file(file_name, <<~CSV)
        Datum ;Zeit ;AT [°C];KT Ist [°C];
        08.12.2020;00:03:24;2,4;39,6;
      CSV

      task.execute from: FakeBoiler.url
    end

    it { expect(importation).to exists }
    it { expect(measure.send(metric.column_name)).to eq(10) }
  end

  context 'when a measure file contains empty line' do
    let(:file_name) { 'touch_20201208.csv' }

    before do
      FakeBoiler.stub_files([file_name])
      FakeBoiler.stub_file(file_name, <<~CSV)
        Datum ;Zeit ;AT [°C];KT Ist [°C];
        10.12.2020;00:03:24;2,4;39,6;

      CSV

      task.execute from: FakeBoiler.url
    end

    it { expect(Measure.count).to eq(1) }
  end

  context 'when a measure file contains unknown column' do
    let(:file_name) { 'touch_20201208.csv' }

    before do
      FakeBoiler.stub_files([file_name])
      FakeBoiler.stub_file(file_name, <<~CSV)
        Datum ;Zeit ;AT [°C];Unknown;
        10.12.2020;00:03:24;2,4;20;
        10.12.2020;00:04:24;1,2;19;
      CSV

      task.execute from: FakeBoiler.url
    end

    it { expect(Measure.count).to eq(2) }

    it { expect(Rails.logger).to have_received(:warn).with(/Unknown metric column 'Unknown'/).once }
  end

  context 'when many measure files contains unknown columns' do
    let(:file_name1) { 'touch_20201208.csv' }
    let(:file_name2) { 'touch_20201209.csv' }

    before do
      FakeBoiler.stub_files([file_name1, file_name2])
      FakeBoiler.stub_file(file_name1, <<~CSV)
        Datum ;Zeit ;AT [°C];Unknown;
        08.12.2020;00:03:24;2,4;20;
      CSV
      FakeBoiler.stub_file(file_name2, <<~CSV)
        Datum ;Zeit ;AT [°C];Unknown;
        09.12.2020;00:03:24;2,4;20;
      CSV

      task.execute from: FakeBoiler.url
    end

    it { expect(Rails.logger).to have_received(:warn).with(/Unknown metric column 'Unknown'/).twice }
  end

  context 'when measure file previously failed to be imported' do
    let(:file_name) { "touch_20200714.csv" }

    before do
      create :importation, :failed, file_name: file_name
      FakeBoiler.stub_files([file_name])
      FakeBoiler.stub_file(file_name, <<~CSV)
        Datum ;Zeit ;AT [°C];KT Ist [°C];
        08.12.2020;00:03:24;2,4;39,6;
      CSV

      task.execute from: FakeBoiler.url
    end

    it { expect(Measure.count).to eq(1) }
    it { expect(Importation.where(file_name: file_name).count).to eq(2) }
  end

  context 'when bad measure file is available' do
    let(:file_name) { "touch_20200714.csv" }

    before do
      FakeBoiler.stub_files([file_name])
      FakeBoiler.stub_file(file_name, <<~CSV)
        Datum ;Zeit ;AT [°C];KT Ist [°C];
        08.12.2020;00:03:24;2,4;39,6;
        invalid date format;00:03:24;2,4;39,6;
        08.12.2020;00:05:24;2,4;39,6;
      CSV

      task.execute from: FakeBoiler.url
    end

    it { expect(Importation.count).to eq(1) }
    it { expect(Importation.take).to be_failed }
    it { expect(Rails.logger).to have_received(:error).with(/Cannot parse row #3/).once }
    it { expect(ActionMailer::Base.deliveries.count).to eq(1) }
  end

  context 'when a file importation failed' do
    subject(:execute_task) { task.execute(from: FakeBoiler.url) }

    before do
      file_name1 = "touch_20200714.csv"
      FakeBoiler.stub_files([file_name1])
      FakeBoiler.stub_file(file_name1, <<~CSV)
        Datum ;Zeit ;AT [°C];KT Ist [°C];
        08.12.2020;00:03:24;2,4;39,6;
      CSV
      file_name2 = "touch_20200714.csv"
      FakeBoiler.stub_files([file_name2])
      FakeBoiler.stub_file(file_name2, <<~CSV)
        Datum ;Zeit ;AT [°C];KT Ist [°C];
        invalid date format;00:03:24;2,4;39,6;
      CSV
    end

    it { expect { execute_task }.to raise_error(ImportationError, "1 importation failed") }
  end
end
