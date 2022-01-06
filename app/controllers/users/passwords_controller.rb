class Users::PasswordsController < Devise::PasswordsController
  before_action :authenticate_user!
  # before_action :require_user_signed_in!

  def update
    @user = User.find(current_user.id)
    if @user.update_with_password(user_params)
      render json: { message: "password updated" }
    else
      render json: { message: @user.errors.objects.first.full_message }
    end
  end

  private

  def user_params
    params.required(:user).permit(:password, :password_confirmation, :current_password)
  end
end
