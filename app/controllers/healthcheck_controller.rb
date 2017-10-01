class HealthcheckController < ApplicationController
  def get
    { status: :ok }
  end
end
