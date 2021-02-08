# frozen_string_literal: true

RSpec::Matchers.define :exists do
  match do |model|
    model.class.exists? model.id
  end
end

RSpec::Matchers.define :be_json do
  match do |response|
    response.content_type == "application/json; charset=utf-8"
  end
end
