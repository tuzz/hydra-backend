class ApplicationController
  def self.get(params)
    new(params).get
  end

  attr_accessor :params

  def initialize(params)
    self.params = params
  end
end
