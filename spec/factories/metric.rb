FactoryBot.define do
  factory :metric do
    sequence(:label) { |i| "Metric ##{i}" }
    sequence(:column_name) { |i| "metric_#{i}" }
  end
end
