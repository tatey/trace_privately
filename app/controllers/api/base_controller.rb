class Api::BaseController < ApplicationController
  skip_forgery_protection

  before_action :authenticate

  protected

  def authenticate
    authenticate_or_request_with_http_token do |token, options|
      AccessGrant.current.where(token: token).exists?
    end
  end
end
