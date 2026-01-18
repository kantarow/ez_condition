module EzCondition
  module Term
    class String
      def initialize(value:)
        raise ArgumentError, 'value must be present' if value.nil?
        raise ArgumentError, 'value must respond to `to_s`' unless value.respond_to?(:to_s)

        @value = value.to_s
      end

      def evaluate(_context)
        @value
      end
    end
  end
end
