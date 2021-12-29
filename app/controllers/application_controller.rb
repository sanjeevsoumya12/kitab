class ApplicationController < ActionController::API
  before_action :configure_permitted_parameters, if: :devise_controller?
  respond_to :json
  before_action :process_token

  rescue_from ActionController::ParameterMissing do |exception|
    render json: { error: exception.message }, status: :bad_request
  end
  rescue_from ActiveRecord::RecordNotUnique do |exception|
    render json: { error: exception.message }, status: :bad_request
  end

  private

  # Check for auth headers - if present, decode or send unauthorized response (called always to allow current_user)
  def process_token
    byebug
    if request.headers["Authorization"].present?
      begin
        jwt_payload = JWT.decode(request.headers["Authorization"].split(" ")[1], Rails.application.secrets.secret_key_base).first
        @current_user_id = jwt_payload["id"]
      rescue JWT::ExpiredSignature, JWT::VerificationError, JWT::DecodeError
        head :unauthorized
      end
    end
  end

  # If user has not signed in, return unauthorized response (called only when auth is needed)
  def authenticate_user!(options = {})
    byebug
    head :unauthorized unless signed_in?
  end

  # set Devise's current_user using decoded JWT instead of session
  def current_user
    byebug
    @current_user ||= super || User.find(@current_user_id)
  end

  # check that authenticate_user has successfully returned @current_user_id (user is authenticated)
  def signed_in?
    byebug
    @current_user_id.present?
  end

  def require_user_signed_in!
    render json: { alert: "you must be signed in to do that " } if @current_user_id.nil?
  end

  protected

  def configure_permitted_parameters
    byebug
    attributes = [:user_name, :phn_number, :date_of_birth, :password_confirmation]
    devise_parameter_sanitizer.permit(:sign_up, keys: attributes)
    # devise_parameter_sanitizer.permit(:account_update, keys: [:user_name, :phn_number, :date_of_birth])
    # devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:user_name, :phn_number, :date_of_birth) }
  end
end
