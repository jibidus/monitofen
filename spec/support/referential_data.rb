def create_referential_data!
  [
    { column_name: 'metric_0', label: 'T extérieure' },
    { column_name: 'metric_1', label: 'TC mes' },
    { column_name: 'metric_2', label: 'TC Ret cons' }
  ].each do |metric|
    Metric.find_or_create_by!(column_name: metric[:column_name]) do |created_metric|
      created_metric.label = metric[:label]
    end
  end
end
