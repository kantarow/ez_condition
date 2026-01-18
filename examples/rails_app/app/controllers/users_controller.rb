# frozen_string_literal: true

class UsersController < ApplicationController
  def index
    @users = User.all

    if params[:switch_to]
      user = User.find(params[:switch_to])
      session[:user_id] = user.id
      redirect_to root_path, notice: "Switched to user: #{user.name}"
    end
  end
end
