class Api::V1::ApiController < ApplicationController
  class Unauthenticated < StandardError; end
  class InvalidAuthorizationToken < Unauthenticated; end
  class MissingAuthorizationToken < Unauthenticated; end
  protect_from_forgery with: :null_session
  before_filter :authenticate!

  rescue_from Exception do |exception|
    error={
      :exception=>exception.message
    }
    render json:error, :status=>500
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
end
