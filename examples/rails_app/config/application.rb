# frozen_string_literal: true

require_relative 'boot'

require 'rails'
require 'active_model/railtie'
require 'active_record/railtie'
require 'action_controller/railtie'
require 'action_view/railtie'
require 'rails/test_unit/railtie'

Bundler.require(*Rails.groups)

module EzConditionExample
  class Application < Rails::Application
    config.load_defaults 7.0
    config.api_only = false

    # Eager load EzCondition
    config.eager_load_paths << Rails.root.join('app', 'services')
  end
end
