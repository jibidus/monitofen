class MeasurementsController < ApplicationController
  def index
    metric = Metric.find(params[:metric_id])
    json = Measurement.where(date: from_param..to_param)
                      .limit(Rails.configuration.max_returned_measurements)
                      .order(date: :asc)
                      .map { |m| { id: m.id, date: m.date, value: m[metric.column_name] } }
    render json: json
  end

  private

  def from_param
    params[:from].to_datetime
  end

  def to_param
    params[:to].to_datetime
  end
end
