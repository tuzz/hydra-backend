module Wikipedia
  module Parser
    class SecondPass
      SENTINEL = "__hydra_nested_template__"

      def self.parse(*params)
        new(*params).parse
      end

      def initialize(input)
        self.input = input
        self.templates = []
      end

      def parse
        input.map { |e| e.is_a?(Array) ? parse_recursive(e) : e }
      end

      private

      attr_accessor :input, :templates

      def parse_recursive(array)
        temporarily_inline_nested_templates(array) do |inlined|
          parse_template(inlined)
        end
      end

      def parse_template(string)
        head, *tail = string.split("|")

        Template.new(
          name: head.strip,
          params: parse_params(tail)
        )
      end

      def parse_params(array)
        @nameless_index = 0
        array.map { |s, i| parse_param(s) }.to_h
      end

      def parse_param(string)
        if string.include?("=")
          parse_named_param(string)
        else
          parse_nameless_param(string)
        end
      end

      def parse_named_param(string)
        key, value = string.split("=").map(&:strip)
        [key, value || ""]
      end

      def parse_nameless_param(string)
        @nameless_index += 1
        ["#@nameless_index", string]
      end

      # Templates can be nested within other templates. This is hard to parse so
      # we temporarily swap these templates for sentinels and embed them in the
      # string. After the top-level template is parsed, we swap these back.
      def temporarily_inline_nested_templates(array)
        nested = self.class.parse(array)
        inlined = swap_templates_for_sentinels(nested)

        template = yield(inlined)
        params = swap_sentinels_for_templates(template.params)

        Template.new(name: template.name, params: params)
      end

      def swap_templates_for_sentinels(array)
        array.map do |element|
          if element.is_a?(Template)
            templates.push(element)
            SENTINEL
          else
            element
          end
        end.join
      end

      def swap_sentinels_for_templates(params)
        params.map do |key, value|
          if value.include?(SENTINEL)
            value = value
              .split(/(#{SENTINEL})/)
              .reject(&:blank?)
              .map { |s| s == SENTINEL ? templates.shift : s }
          end

          [key, value]
        end.to_h
      end
    end
  end
end
