class Api::V1::ApiController < ApplicationController
  class Unauthenticated < StandardError; end
  class InvalidAuthorizationToken < Unauthenticated; end
  class MissingAuthorizationToken < Unauthenticated; end
  protect_from_forgery with: :null_session
  before_filter :authenticate!

  rescue_from Exception do |exception|
    text_admin(exception.message)
    raise exception
  end

  rescue_from ActiveRecord::NoDatabaseError do |exception|
    text_admin(exception.message)
    render json:{ error: "System down, sorry for the inconvienience!" }, :status=>500
  end

  rescue_from Unauthenticated do |exception|
    render json: { error: "System cannot authenticate you without a valid token based authentication header."}
  end

  rescue_from MissingAuthorizationToken do |exception|
    render json: { error: "Missing authentication token header"}
  end

  rescue_from InvalidAuthorizationToken do |exception|
    render json: { error: "Provided authentication token did not match any valid sessions."}
  end

  def authenticate!
    token=authenticate_with_http_token { |token| token }
    raise MissingAuthorizationToken.new unless token
    session=Session.where(:token=>token).first
    raise InvalidAuthorizationToken.new unless session && session.current_user
    @current_user=session.user
  end

  def current_user
    @current_user
  end

  def text_admin(message)
    puts "System has experienced a system error, lets tell the admin!"
  end
end
