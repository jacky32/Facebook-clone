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
    end
    render formats: :turbo_stream, template: 'dashboard/search'
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
