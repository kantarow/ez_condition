module EzCondition
  module Term
    class BinaryOperator
      attr_reader :left, :right

      def initialize(left:, right:)
        raise ArgumentError, "#{self.class.name} left operand must be present" if left.nil?
        raise ArgumentError, "#{self.class.name} right operand must be present" if right.nil?

        @left = left
        @right = right
      end

      def evaluate(context)
        raise NotImplementedError, 'Subclasses must implement the evaluate method'
      end
    end
  end
end
