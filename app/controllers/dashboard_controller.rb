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

  def search
    query
    if @query.blank?
      'No results'
    else
      @result_users = User.search(@query)
      @result_communities = Community.search(@query)
    end
    render formats: :turbo_stream, template: 'dashboard/search'
  end

  def search_results
    if params[:user_id]
      @option = 'user'
      @user = User.find(params[:user_id])
    elsif params[:community_id]
      @option = 'community'
      @community = Community.find(params[:community_id])
    end
    render formats: :turbo_stream, template: 'dashboard/search_results'
  end

  private

  def query
    @query = params[:query]
  end

  def decide
    @option = params[:option]
    @id = params[:option_id]
  end
end
