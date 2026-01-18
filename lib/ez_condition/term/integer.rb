module EzCondition
  module Term
    class Integer
      def initialize(*args, value: nil)
        value = args.first if value.nil? && !args.empty?
        raise ArgumentError, 'value must be present' if value.nil?
        raise ArgumentError, 'value must respond to `to_i`' unless value.respond_to?(:to_i)

        @value = value.to_i
      end

      def evaluate(_context)
        @value
      end
    end
  end
end
