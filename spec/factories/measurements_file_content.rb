module MeasurementsFileContent
  def self.build(date: Date.new(2001, 2, 25))
    "Datum ;Zeit ;AT [°C];KT Ist [°C];
#{date.strftime('%d.%m.%Y')};00:03:24;2,4;39,6;
"
  end

  def self.build_invalid
    "Datum ;Zeit ;AT [°C];KT Ist [°C];
invalid date;00:03:24;2,4;39,6;
"
  end
end
