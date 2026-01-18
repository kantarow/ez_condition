require_relative 'binary_operator'

module EzCondition
  module Term
    class And < BinaryOperator
      def evaluate(context)
        left.evaluate(context) && right.evaluate(context)
      end
    end
  end
end
