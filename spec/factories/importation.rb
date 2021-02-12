FactoryBot.define do
  factory :importation do
    file_name { "touch_#{Time.zone.now.strftime('%Y%m%d')}.csv" }
    status { :successful }

    trait :running do
      status { :running }
    end
    trait :successful do
      status { :successful }
    end
    trait :failed do
      status { :failed }
    end
  end
end
