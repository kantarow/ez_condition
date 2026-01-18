module EzCondition
  module Term
    class Not
      def initialize(operand:)
        @operand = operand
      end

      def evaluate(context)
        !@operand.evaluate(context)
      end
    end
  end
end
