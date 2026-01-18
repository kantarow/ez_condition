# frozen_string_literal: true

class User < ApplicationRecord
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :role, inclusion: { in: %w[admin manager member] }
  validates :department, presence: true
  validates :age, numericality: { greater_than: 0 }

  # Convert user attributes to context hash for EzCondition evaluation
  def to_context
    {
      'role' => role,
      'department' => department,
      'age' => age,
      'active' => active
    }
  end

  # Check if user has permission to perform action on resource
  def can?(action, resource)
    rules = resource.access_rules.where(action: action.to_s)
    rules.any? { |rule| rule.evaluate_for(self) }
  end
end
