require_relative 'term/and'
require_relative 'term/binary_operator'
require_relative 'term/boolean'
require_relative 'term/equal'
require_relative 'term/integer'
require_relative 'term/not'
require_relative 'term/or'
require_relative 'term/statement'
require_relative 'term/string'
require_relative 'term/var'

module EzCondition
  class Parser
    VAR_STR = 'var'.freeze
    AND_STR = 'and'.freeze
    OR_STR = 'or'.freeze
    NOT_STR = 'not'.freeze
    EQUAL_STR = 'equal'.freeze
    STRING_STR = 'string'.freeze
    INTEGER_STR = 'integer'.freeze
    BOOLEAN_STR = 'boolean'.freeze

    def parse(expr) # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/MethodLength
      return nil if expr.nil? || expr.empty?

      case expr['type']
      when VAR_STR
        Term::Var.new(name: expr['name'])
      when AND_STR
        parse_binary_operator(expr, Term::And)
      when OR_STR
        parse_binary_operator(expr, Term::Or)
      when EQUAL_STR
        parse_binary_operator(expr, Term::Equal)
      when NOT_STR
        Term::Not.new(operand: parse(expr['operand']))
      when STRING_STR
        Term::String.new(value: expr['value'])
      when INTEGER_STR
        Term::Integer.new(value: expr['value'])
      when BOOLEAN_STR
        Term::Boolean.new(value: expr['value'])
      else
        raise "Unknown expr type: #{expr['type']}"
      end
    end

    private

    def parse_binary_operator(expr, klass)
      left = parse(expr['left'])
      right = parse(expr['right'])
      klass.new(left:, right:)
    end
  end
end
