module EzCondition
  module Term
    class Boolean
      def initialize(value:)
        raise ArgumentError, 'value must be true or false' unless %w[true false].include?(value)

        @value = value
      end

      def evaluate(_context)
        @value == 'true'
      end
    end
  end
end
