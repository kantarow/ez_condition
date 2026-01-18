# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :set_current_user

  private

  def set_current_user
    # In a real app, this would come from authentication system
    # For demo purposes, we'll use the first user or allow selection
    @current_user = if session[:user_id]
                      User.find_by(id: session[:user_id])
                    else
                      User.first
                    end

    @current_user ||= User.first
    session[:user_id] = @current_user&.id
  end
end
