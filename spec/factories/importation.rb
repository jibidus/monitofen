FactoryBot.define do
  factory :importation do
    file_name { "touch_#{Time.zone.now.strftime('%Y%m%d')}.csv" }
  end
end
