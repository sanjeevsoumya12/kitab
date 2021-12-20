class Users::RegistrationsController < Devise::RegistrationsController
  def create
    user = User.new(sign_up_params)

    if user.save
      @email_mailer = NewUserEmailMailer.notify_user(user).deliver
      render json: @email_mailer
      # token = user.generate_jwt
      # render json: token.to_json
    else (!user[:username])
      render json: { message: user.errors.objects.first.full_message }, status: :bad_request     end
  end
end
