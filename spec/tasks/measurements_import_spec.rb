require 'rails_helper'
require 'csv_metric_mapper'
require 'tempfile'

RSpec.describe 'measurements:import', type: :task do
  before do
    allow(Rails.logger).to receive(:info)
    allow(Rails.logger).to receive(:warn)
    allow(Rails.logger).to receive(:error)
    FakeBoiler.reset
  end

  context 'when no parameter provided' do
    it { expect { task.execute }.to raise_error(Rake::TaskArgumentError) }
  end

  context 'when no file is available' do
    before do
      FakeBoiler.stub_files_index []
      task.execute from: FakeBoiler.url
    end

    it { expect(Importation.count).to eq(0) }
    it { expect(Measurement.count).to eq(0) }
  end

  context 'when file path given' do
    let(:file) do
      Tempfile.new(%w[touch_20201210 .csv]).tap do |f|
        f << <<~CSV
          Datum ;Zeit ;AT [°C];KT Ist [°C];
          10.12.2020;00:03:24;2,4;39,6;
          10.12.2020;00:04:24;2,4;39,6;
        CSV
        f.close
      end
    end

    before { task.execute from: file.path }

    after { file.unlink }

    it { expect(Importation.count).to eq(1) }
    it { expect(Rails.logger).to have_received(:info).with(/File "touch_20201210.*\.csv" successfully imported./).once }
  end

  context 'when files are available but not CSV' do
    before do
      FakeBoiler.stub_file "graph_20201220.png"
      task.execute from: FakeBoiler.url
    end

    it { expect(Importation.count).to eq(0) }
  end

  context 'when only titles.csv is available' do
    before do
      FakeBoiler.stub_file "titles.csv"
      task.execute from: FakeBoiler.url
    end

    it { expect(Importation.count).to eq(0) }
  end

  context 'when one measurement file is available' do
    let(:measurement_date) { Time.zone.local(2020, 12, 10, 0, 3, 24) }
    let(:file_name) { "touch_#{measurement_date.strftime('%Y%m%d')}.csv" }

    before do
      FakeBoiler.stub_file file_name, <<~CSV
        Datum ;Zeit ;AT [°C];KT Ist [°C];
        #{measurement_date.strftime('%d.%m.%Y')};#{measurement_date.strftime('%H:%M:%S')};2,4;39,6;
      CSV

      task.execute from: FakeBoiler.url
    end

    it { expect(Importation.count).to eq(1) }

    it { expect(Measurement.count).to eq(1) }

    it 'creates measurements with values from CSV' do
      measurement = Measurement.find_by!(date: measurement_date)
      metric = Metric.find_by!(label: MAPPING['KT Ist [°C]'])
      value = measurement.send(metric.column_name)
      expect(value).to eq(39.6)
    end

    it { expect(Rails.logger).to have_received(:info).with(/Import file #{file_name}/) }

    it {
      expected_log = /File "touch_20201210\.csv" successfully imported with 1 measurement\(s\) in .*s\./
      expect(Rails.logger).to have_received(:info).with(expected_log)
    }

    it { expect(ActionMailer::Base.deliveries.count).to eq(1) }
  end

  context 'when many measurement files are available' do
    before do
      FakeBoiler.stub_measurement_file
      FakeBoiler.stub_measurement_file
      task.execute from: FakeBoiler.url
    end

    it { expect(Importation.count).to eq(2) }
  end

  context 'when a measurement file is available for today' do
    before do
      FakeBoiler.stub_measurement_file date: Time.zone.today
      task.execute from: FakeBoiler.url
    end

    it { expect(Importation.count).to eq(0) }
  end

  context 'when measurement file not complete (i.e. today)' do
    let(:file_date) { Time.zone.today }
    let(:file_name) { "touch_#{file_date.strftime('%Y%m%d')}.csv" }

    before do
      FakeBoiler.stub_file file_name, MeasurementsFileContent.build
      task.execute from: FakeBoiler.url
    end

    it { expect(Rails.logger).to have_received(:info).with("File \"#{file_name}\" skipped (not complete)").once }
    it { expect(Rails.logger).to have_received(:info).with(%r{0/0 file\(s\) imported successfully.}).once }
    it { expect(Rails.logger).to have_received(:info).with(/1 skipped/).once }
  end

  context 'when measurement file already imported successfully' do
    let(:file_date) { DateTime.new(2020, 12, 8, 20, 10, 0) }
    let(:file_name) { "touch_#{file_date.strftime('%Y%m%d')}.csv" }
    let(:next_file_name) { "touch_#{file_date.next_day.strftime('%Y%m%d')}.csv" }
    let(:importation) { create(:importation, :successful, file_name: file_name) }

    before do
      importation
      FakeBoiler.stub_file file_name, MeasurementsFileContent.build
      FakeBoiler.stub_file next_file_name, MeasurementsFileContent.build
      task.execute from: FakeBoiler.url
    end

    it { expect(importation).to exists }
    it { expect(Rails.logger).to have_received(:info).with("File \"#{file_name}\" skipped (already imported)").once }
    it { expect(Rails.logger).to have_received(:info).with(/File "#{next_file_name}" successfully imported/).once }
    it { expect(Rails.logger).to have_received(:info).with(%r{1/1 file\(s\) imported successfully.}).once }
    it { expect(Rails.logger).to have_received(:info).with(/1 skipped/).once }
  end

  context 'when a measurement file ends with empty line' do
    let(:file_name) { 'touch_20201208.csv' }

    before do
      FakeBoiler.stub_file file_name, <<~CSV
        Datum ;Zeit ;AT [°C];KT Ist [°C];
        10.12.2020;00:03:24;2,4;39,6;

      CSV
      task.execute from: FakeBoiler.url
    end

    it { expect(Measurement.count).to eq(1) }
  end

  context 'when a measurement file contains unknown column' do
    let(:file_name) { 'touch_20201208.csv' }

    before do
      FakeBoiler.stub_file file_name, <<~CSV
        Datum ;Zeit ;AT [°C];Unknown;
        10.12.2020;00:03:24;2,4;20;
        10.12.2020;00:04:24;1,2;19;
      CSV
      task.execute from: FakeBoiler.url
    end

    it { expect(Measurement.count).to eq(2) }

    it { expect(Rails.logger).to have_received(:warn).with(/Unknown metric column 'Unknown'/).once }
  end

  context 'when many measurement files contains unknown columns' do
    before do
      FakeBoiler.stub_file "touch_20201208.csv", <<~CSV
        Datum ;Zeit ;AT [°C];Unknown;
        08.12.2020;00:03:24;2,4;20;
      CSV
      FakeBoiler.stub_file "touch_20201209.csv", <<~CSV
        Datum ;Zeit ;AT [°C];Unknown;
        09.12.2020;00:03:24;2,4;20;
      CSV
      task.execute from: FakeBoiler.url
    end

    it { expect(Rails.logger).to have_received(:warn).with(/Unknown metric column 'Unknown'/).twice }
    it { expect(Rails.logger).to have_received(:info).with(%r{2/2 file\(s\) imported successfully.}).once }
  end

  context 'when retrying file importation after failure' do
    let(:file_name) { "touch_20200714.csv" }

    before do
      create :importation, :failed, file_name: file_name
      FakeBoiler.stub_file file_name, MeasurementsFileContent.build
      task.execute from: FakeBoiler.url
    end

    it { expect(Measurement.count).to eq(1) }
    it { expect(Importation.where(file_name: file_name).count).to eq(2) }
    it { expect(Rails.logger).to have_received(:info).with(%r{1/1 file\(s\) imported successfully.}).once }
  end

  context 'when bad measurement file is available' do
    let(:file_name) { "touch_20200714.csv" }

    before do
      FakeBoiler.stub_file file_name, <<~CSV
        Datum ;Zeit ;AT [°C];KT Ist [°C];
        08.12.2020;00:03:24;2,4;39,6;
        invalid date format;00:03:24;2,4;39,6;
        08.12.2020;00:05:24;2,4;39,6;
      CSV

      task.execute from: FakeBoiler.url
    rescue ImportationError
      # Expected exception
    end

    it { expect(Importation.count).to eq(1) }
    it { expect(Importation.take).to be_failed }
    it { expect(Rails.logger).to have_received(:error).with(/Cannot parse row #3/).once }
    it { expect(Rails.logger).to have_received(:info).with(%r{0/1 file\(s\) imported successfully.}).once }
    it { expect(ActionMailer::Base.deliveries.count).to eq(1) }
  end

  context 'when many file importation failed' do
    subject(:execute_task) { task.execute(from: FakeBoiler.url) }

    before do
      FakeBoiler.stub_measurement_file content: MeasurementsFileContent.build_invalid
      FakeBoiler.stub_measurement_file content: MeasurementsFileContent.build_invalid
    end

    it { expect { execute_task }.to raise_error(ImportationError, "2 importation(s) failed") }
  end

  context 'when several files imported and some has failed' do
    before do
      FakeBoiler.stub_measurement_file content: MeasurementsFileContent.build
      FakeBoiler.stub_measurement_file content: MeasurementsFileContent.build_invalid
    end

    it 'throws exception' do
      expect { task.execute(from: FakeBoiler.url) }.to raise_error(ImportationError)
    end

    it 'logs importation status' do
      task.execute from: FakeBoiler.url
    rescue ImportationError
      expect(Rails.logger).to have_received(:info).with(%r{1/2 file\(s\) imported successfully.}).once
    end
  end

  # TODO: test logs are ordered by files
  # TODO: test next files are imported even if 1 is skipped earlier
  # TODO: No skip logs when 0
end
