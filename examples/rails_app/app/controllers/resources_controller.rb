# frozen_string_literal: true

class ResourcesController < ApplicationController
  before_action :set_resource, only: [:show]

  def index
    @resources = Resource.all
  end

  def show
    unless @current_user.can?('read', @resource)
      flash[:alert] = 'Access Denied: You do not have permission to view this resource.'
      redirect_to resources_path
      return
    end

    @access_rules = @resource.access_rules
  end

  private

  def set_resource
    @resource = Resource.find(params[:id])
  end
end
