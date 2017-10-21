module Wikipedia
  class Template
    attr_accessor :name, :params

    def initialize(name:, params: {})
      self.name = name
      self.params = params
    end

    def ==(other)
      name == other.name && params == other.params
    end
  end
end
