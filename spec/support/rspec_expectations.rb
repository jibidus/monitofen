# frozen_string_literal: true

RSpec::Matchers.define :exists do
  match do |model|
    model.class.exists? model.id
  end
end
