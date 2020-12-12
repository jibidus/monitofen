RSpec.configure do |config|
  config.before(:each) do
    WebMock.reset!
  end
end