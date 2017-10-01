module RequestHelper
  include Rack::Test::Methods

  def app
    Rack::Builder.parse_file("config.ru").first
  end

  def body
    JSON.parse(last_response.body).deep_symbolize_keys
  end
end
