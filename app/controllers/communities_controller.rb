class CommunitiesController < ApplicationController
  before_action :authenticate_user!
  before_action :community, only: %i[show update destroy]

  def index
    @community_posts = current_user.community_posts
  end

  def create
    @community = current_user.created_communities.create(community_params.merge(admin_id: current_user.id))
    respond_to do |format|
      if @community.save
        format.html { redirect_to community_path(@community), notice: 'Community created!' }
        format.turbo_stream { flash.now[:notice] = 'Community created!' }
      else
        format.html { redirect_to communities_path, status: :unprocessable_entity, alert: 'Community was not created' }
        format.turbo_stream { flash.now[:alert] = 'Community was not created' } # returns status OK
      end
    end
  end

  def show; end

  def update
    respond_to do |format|
      if @community.update(community_params)
        format.html { redirect_to community_path(@community), notice: 'Community edited!' }
        format.turbo_stream { flash.now[:notice] = 'Community edited!' }
      else
        format.html do
          redirect_to community_path(@community), status: :unprocessable_entity, alert: 'Community was not edited!'
        end
        format.turbo_stream { flash.now[:alert] = 'Community was not edited!' }
      end
    end
  end

  def destroy
    respond_to do |format|
      if @community.destroy
        format.html { redirect_to root_path, notice: 'Community deleted!' }
        format.turbo_stream { flash.now[:notice] = 'Community deleted!' }
      else
        format.html do
          redirect_to community_path(@community), status: :unprocessable_entity, alert: 'Community was not deleted!'
        end
        format.turbo_stream { flash.now[:alert] = 'Community was not deleted!' }
      end
    end
  end

  private

  def community
    @community ||= Community.find(params[:id])
  end

  def community_params
    params.require(:community).permit(:name, :info, :background, :is_private)
  end
end
