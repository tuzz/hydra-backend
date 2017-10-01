module Hydra
  class Backend < Grape::API
    format :json
    version :v1

    get("/") { HealthcheckController.get(params) }
  end
end
