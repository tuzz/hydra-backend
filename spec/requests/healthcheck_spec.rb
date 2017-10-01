RSpec.describe "/v1/" do
  include RequestHelper

  it "responds with a healthcheck" do
    get "/v1/"
    expect(body).to eq(status: "ok")
  end
end
