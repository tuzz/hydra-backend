module Wikipedia
  class Visitor
    def self.visit(*args)
      new(*args).visit
    end

    def initialize(input)
      self.input = input
    end

    def visit
      Enumerator.new { |y| visit_node(input, y) }
    end

    private

    attr_accessor :input

    def visit_node(node, yielder)
      case node
      when Array
        visit_array(node, yielder)
      when Template
        visit_template(node, yielder)
      end
    end

    def visit_array(array, yielder)
      array.each { |e| visit_node(e, yielder) }
    end

    def visit_template(template, yielder)
      yielder.yield(template)
      template.params.each { |_, v| visit_node(v, yielder) }
    end
  end
end
