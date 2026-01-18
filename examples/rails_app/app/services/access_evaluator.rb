# frozen_string_literal: true

class AccessEvaluator
  def initialize(access_rule, user)
    @access_rule = access_rule
    @user = user
    @parser = EzCondition::Parser.new
  end

  def evaluate
    return false if @access_rule.condition.blank?

    parsed_condition = @parser.parse(@access_rule.condition)
    return false if parsed_condition.nil?

    context = @user.to_context
    parsed_condition.evaluate(context)
  rescue StandardError => e
    Rails.logger.error("AccessEvaluator error: #{e.message}")
    Rails.logger.error(e.backtrace.join("\n"))
    false
  end
end
