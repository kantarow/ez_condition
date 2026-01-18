# frozen_string_literal: true

class AccessRulesController < ApplicationController
  def index
    @access_rules = AccessRule.includes(:resource).all
  end

  def new
    @access_rule = AccessRule.new
    @resources = Resource.all
  end

  def create
    @access_rule = AccessRule.new(access_rule_params)

    if @access_rule.save
      redirect_to access_rules_path, notice: 'Access rule was successfully created.'
    else
      @resources = Resource.all
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @access_rule = AccessRule.find(params[:id])
    @resources = Resource.all
  end

  def update
    @access_rule = AccessRule.find(params[:id])

    if @access_rule.update(access_rule_params)
      redirect_to access_rules_path, notice: 'Access rule was successfully updated.'
    else
      @resources = Resource.all
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def access_rule_params
    permitted = params.require(:access_rule).permit(:resource_id, :name, :action, :condition)

    # Parse condition from JSON string if needed
    if permitted[:condition].is_a?(String)
      begin
        permitted[:condition] = JSON.parse(permitted[:condition])
      rescue JSON::ParserError => e
        # If parsing fails, let validation handle it
        Rails.logger.error("Failed to parse condition JSON: #{e.message}")
      end
    end

    permitted
  end
end
