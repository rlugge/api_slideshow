class Api::V1::ApiController < ApplicationController
  protect_from_forgery with: :null_session
  before_filter :authenticate!

  def authenticate!
    authenticate_or_request_with_http_token do |token, options|
      @current_user=Session.where(:token=>token).first.user
    end
  end

  def current_user
    @current_user
  end
end
