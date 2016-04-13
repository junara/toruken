class StaticPagesController < ApplicationController
  def home
    @photo = current_user.photos.build if logged_in?
  end
end
