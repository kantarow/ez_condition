module EzCondition
  module Term
    class Var
      def initialize(name:)
        raise ArgumentError, 'name must be present' if name.nil?

        @name = name
      end

      def evaluate(context)
        val = context[@name.to_s]
        raise "Undefined variable `#{@name}`" if val.nil?

        val
      end
    end
  end
end
