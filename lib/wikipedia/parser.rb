module Wikipedia
  module Parser
    def self.parse(input)
      data = FirstPass.parse(input)
      SecondPass.parse(data)
    end
  end
end
