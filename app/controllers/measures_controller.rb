class MeasuresController < ApplicationController
  def index
    metric = Metric.find(params[:metric_id])
    measures = Measure.select(metric)
    render json: measures
  end
end
