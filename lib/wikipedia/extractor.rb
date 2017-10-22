module Wikipedia
  class Extractor
    FOOTBALL_KIT_KEYS = %w(alt pattern_la pattern_b pattern_ra pattern_sh
      pattern_so leftarm body rightarm shorts socks title)

    FOOTBALL_CLUB_KEYS = %w(kit_alt pattern_la pattern_b pattern_ra pattern_sh
      pattern_so leftarm body rightarm shorts socks pattern_name)

    def self.extract(*args)
      new(*args).extract
    end

    def initialize(input)
      self.input = input
      self.extracted = []
    end

    def extract
      Visitor.visit(input).each do |template|
        params = template.params

        case template.name
        when "Football kit"
          extract_football_kit(params)
        when "Infobox football club"
          extract_football_club(params)
        end
      end

      extracted
    end

    private

    def extract_football_kit(params)
      extracted << Template.new(name: "Football kit", params: cleanup(params))
    end

    def extract_football_club(params)
      1.upto(3) { |n| extract_football_kit_from_club(params, n) }
    end

    def extract_football_kit_from_club(params, number)
      keys = numbered(FOOTBALL_CLUB_KEYS, number)

      params = keys.map.with_index do |key, index|
        [FOOTBALL_KIT_KEYS[index], params[key]]
      end.to_h

      extract_football_kit(params)
    end

    def numbered(keys, number)
      keys.map { |k| [k, number].join }
    end

    def cleanup(params)
      params = params.slice(*FOOTBALL_KIT_KEYS)
      params.each { |k, v| params[k] = strip_comment(v) }
      params.each { |k, v| params[k] = v.presence }
    end

    def strip_comment(value)
      return unless value

      parts = value.split("<!--")
      return unless parts.any?

      parts.first.strip
    end

    attr_accessor :input, :extracted
  end
end
