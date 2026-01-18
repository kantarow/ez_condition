# frozen_string_literal: true

class Resource < ApplicationRecord
  has_many :access_rules, dependent: :destroy

  validates :name, presence: true
  validates :resource_type, presence: true
end
