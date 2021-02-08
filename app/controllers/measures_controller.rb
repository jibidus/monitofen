class MeasuresController < ApplicationController
  def index
    measures = Measure.all
    render json: measures
  end
end
