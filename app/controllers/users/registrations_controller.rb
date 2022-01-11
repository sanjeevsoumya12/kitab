class Users::RegistrationsController < Devise::RegistrationsController
  before_action :authenticate_user!, only: [:update]
  # before_action :require_user_signed_in!, only: [:update]

  def create
    user = User.new(sign_up_params)

    if user.save
      @email_mailer = NewUserEmailMailer.notify_user(user).deliver
      render json: { email_mailer: @email_mailer, message: "registration successful" }
      # token = user.generate_jwt
      # render json: token.to_json
    else
      render json: { message: user.errors.objects.first.full_message }, status: :bad_request
    end
  end

  def update
    @user = User.find(current_user.id)
    if @user.update(user_params)
      render json: { message: "Details Updated" }
    else
      render json: { message: @user.errors.ojects.first.full_message }
    end
  end

  #  access to admin
  # def update
  #   @user = User.find(current_user.id)
  #   if (current_user && current_user.admin)
  #     if @user.update(user_params)
  #       render json: { message: "Details Updated" }
  #     else
  #       render json: { message: @user.errors.ojects.first.full_message }
  #     end
  #   else
  #     render json: { message: "you are not access" }
  #   end
  # end

  private

  def user_params
    params.require(:user).permit(:user_name, :phn_number, :date_of_birth)
  end
end
