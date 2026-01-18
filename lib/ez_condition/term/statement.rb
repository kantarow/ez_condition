module EzCondition
  module Term
    class Statement
      def initialize(lines:)
        raise ArgumentError, 'lines must be an array' unless lines.is_a?(Array)

        @lines = lines
      end

      def evaluate(context)
        last_evaluation = nil

        @lines.each do |line|
          last_evaluation = line.evaluate(context)
        end

        last_evaluation
      end
    end
  end
end
