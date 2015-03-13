class Api::V1::ApiController < ApplicationController
  class Unauthenticated < StandardError; end
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

  def authenticate!
    authenticate_with_http_token do |token, options|
      session=Session.where(:token=>token).first
      raise Unauthenticated.new unless session
      @current_user=session.user
    end
    raise Unauthenticated.new unless @current_user
  end

  def current_user
    @current_user
  end
end
