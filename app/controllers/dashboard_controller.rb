class DashboardController < ApplicationController
  before_action :authenticate_user!
  def show
    @posts = current_user.friends_posts
  end

  def modal
    decide
    @selected = params[:selected]
    respond_to do |format|
      format.turbo_stream do
        render 'dashboard/modal'
      end
    end
  end

  def decide
    @option = if params[:post_id]
                'posts'
              elsif params[:comment_id]
                'comments'
              end
    @id = if params[:post_id]
            params[:post_id]
          elsif params[:comment_id]
            params[:comment_id]
          end
  end
end
