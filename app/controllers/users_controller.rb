class UsersController < ApplicationController
  allow_unauthenticated_access only: %i[ new create ]
  layout "logged_out",  only: %i[ new create ]

  before_action :get_current_user, only: %i[ show ]

  def new
    @user = User.new
    @school_code = school_code
  end

  def create
    @user = User.build(user_params)
    @school_code = school_code
    if school_code == "1234" && @user.save
      start_new_session_for @user
      redirect_to after_authentication_url, notice: "Account created successfully."
    else
      flash.now[:alert] = "There were errors creating your account."
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @pagehead = "#{@user.possessive} profile"
  end

  private
  
  def get_current_user
    @user = current_user
    raise ActiveRecord::RecordNotFound unless @user
  end

  def user_params
    params.require(:user).permit(:username, :email_address, :password, :password_confirmation)
  end

  def school_code
    Rails.env.development? ? "1234" : school_code
  end
end