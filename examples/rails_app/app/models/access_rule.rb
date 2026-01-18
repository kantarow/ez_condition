# frozen_string_literal: true

class AccessRule < ApplicationRecord
  belongs_to :resource

  validates :name, presence: true
  validates :condition, presence: true
  validates :action, inclusion: { in: %w[read write delete] }

  # Evaluate this rule for a given user
  def evaluate_for(user)
    AccessEvaluator.new(self, user).evaluate
  end
end
