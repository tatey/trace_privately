class Api::AccessGrantsController < ApplicationController
  skip_forgery_protection

  def create
    @access_grant = AccessGrant.create! # TODO: This should verify the client is genuine. On iOS a payload is given that can be used to verify the app is a genuine installation with Apple.
  end
end
