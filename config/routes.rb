module Hydra
  class Backend < Grape::API
    format :json
    version :v1

    get "/" do
      { hello: "world" }
    end
  end
end
