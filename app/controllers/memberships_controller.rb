class MembershipsController < ApplicationController
  before_action :membership, only: %i[update destroy]
  before_action :community, only: %i[update destroy]
  # before_action :user, only: %i[create update destroy]

  # def accept_request
  #   @friend_request = Friendship.find(params[:friendship_id])
  #   @friend_request.accepted = true
  #   @friend_request.save
  # end

  def create
    @user = User.find(params[:user_id])
    @community = Community.find(params[:community_id])
    @community.members << @user unless Membership.exists?(member_id: @user.id, community_id: @community.id)
    @membership = Membership.where(member_id: @user.id, community_id: @community.id).first

    respond_to do |format|
      if @membership.invited == true
        format.turbo_stream { flash.now[:alert] = 'Already invited!' }
      else
        @membership.invited = true
        @membership.save
        format.turbo_stream { flash.now[:notice] = 'Friend invited!' }
      end
    end
  end

  def update
    @membership.confirmed_by_admin = true
    respond_to do |format|
      if @membership.save
        format.html { redirect_to community_path(@community), notice: 'Member added!' }
        format.turbo_stream { flash.now[:notice] = 'Member added!' }
      else
        format.html do
          redirect_to community_path(@community), status: :unprocessable_entity, alert: 'Unable to add the member!'
        end
        format.turbo_stream { flash.now[:alert] = 'Unable to add the member!' }
      end
    end
  end

  def destroy
    respond_to do |format|
      if @membership.destroy
        format.html { redirect_to root_path, notice: 'Member removed!' }
        format.turbo_stream { flash.now[:notice] = 'Member removed!' }
      else
        format.html { redirect_to root_path, status: :unprocessable_entity, alert: 'Unable to remove the member!' }
        format.turbo_stream { flash.now[:alert] = 'Unable to remove the member!' }
      end
    end
  end

  private

  def membership
    @membership ||= Membership.find(params[:id])
  end

  def community
    @community ||= @membership.community
  end
end
