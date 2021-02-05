# frozen_string_literal: true

require 'rails_helper'
require 'measures_importer'

RSpec.describe 'measures:import', type: :task do
  before do
    allow(Rails.logger).to receive(:info)
    allow(Rails.logger).to receive(:warn)
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
    let(:file_date) { Time.zone.local(2020, 12, 10, 0, 3, 24) }
    let(:file_name) { "touch_#{file_date.strftime('%Y%m%d')}.csv" }

    before do
      FakeBoiler.stub_files([file_name])
      FakeBoiler.stub_file(file_name, <<~CSV)
        Datum ;Zeit ;AT [°C];KT Ist [°C];
        10.12.2020;00:03:24;2,4;39,6;
        10.12.2020;00:04:24;2,4;39,6;
      CSV

      task.execute from: FakeBoiler.url
    end

    it { expect(Importation.count).to eq(1) }

    it { expect(Measure.count).to eq(2) }

    it 'creates measures with values from CSV' do
      measure = Measure.find_by!(date: file_date)
      metric = Metric.find_by!(label: CSV_MAPPING['KT Ist [°C]'])
      value = measure.send(metric.column_name)
      expect(value).to eq(39.6)
    end

    it { expect(Rails.logger).to have_received(:info).with(/Import file #{file_name}/) }

    it { expect(Rails.logger).to have_received(:info).with(/2 measure\(s\) imported/) }
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

    it do
      expect(Rails.logger).to have_received(:info)
        .with(/File #{file_name} skipped: partial content, today's measures/)
        .once
    end
  end

  context 'when measure file already imported' do
    let(:file_date) { DateTime.new(2020, 12, 8, 20, 10, 0) }
    let(:file_name) { "touch_#{file_date.strftime('%Y%m%d')}.csv" }
    let(:importation) { Importation.create!(file_name: file_name) }
    let(:metric) { Metric.find_by!(label: CSV_MAPPING['AT [°C]']) }

    before do
      Measure.create!(
        date: file_date,
        "#{metric.column_name}": 10,
        importation: importation
      )

      FakeBoiler.stub_files([file_name])
      FakeBoiler.stub_file(file_name, <<~CSV)
        Datum ;Zeit ;AT [°C];KT Ist [°C];
        08.12.2020;00:03:24;2,4;39,6;
      CSV

      task.execute from: FakeBoiler.url
    end

    it { expect(Importation).not_to exist(importation.id) }
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
        Datum ;Zeit ;AT [°C];Unknown column;
        10.12.2020;00:03:24;2,4;20;
        10.12.2020;00:04:24;1,2;19;
      CSV

      task.execute from: FakeBoiler.url
    end

    it { expect(Measure.count).to eq(2) }

    it { expect(Rails.logger).to have_received(:warn).with(/Unknown column/).once }
  end
end
