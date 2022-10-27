class DashboardController < ApplicationController
  before_action :authenticate_user!
  def show
    @posts = current_user.friends_posts
  end

  def modal
    @post = params[:id]
    @selected = params[:selected]
    respond_to do |format|
      format.turbo_stream do
        render 'dashboard/modal'
      end
    end
  end
end
