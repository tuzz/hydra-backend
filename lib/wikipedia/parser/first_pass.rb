module Wikipedia
  module Parser
    class FirstPass
      OPEN = "{{"
      CLOSE = "}}"
      PARENS = /#{OPEN}|#{CLOSE}/m

      def self.parse(*args)
        new(*args).parse
      end

      def initialize(source)
        self.scanner = StringScanner.new(source)
      end

      def parse
        head = scan_until_parens.strip
        parens = scan_parens

        if parens == OPEN
          [head, parse, *parse].reject(&:blank?)
        else
          [head]
        end
      end

      private

      attr_accessor :scanner

      def scan_until_parens
        positive_lookahead = /(?=#{PARENS}|\z)/m
        scanner.scan(/.*?#{positive_lookahead}/m)
      end

      def scan_parens
        scanner.scan(PARENS)
      end
    end
  end
end
