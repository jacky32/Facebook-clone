class MembershipsController < ApplicationController
  before_action :authenticate_user!
  before_action :membership, only: %i[request_unsend update destroy]
  before_action :community

  def create
    return request_join if params[:request_send]
    return request_unsend if params[:request_unsend]
    return invite if params[:invite]

    @user = current_user
    @community.members << @user unless Membership.exists?(member_id: @user.id, community_id: @community.id)
    @membership = Membership.where(member_id: @user.id, community_id: @community.id).first

    respond_to do |format|
      if @membership.invited == true
        format.turbo_stream { flash.now[:alert] = 'Already invited!' }
        format.html { redirect_to root_path }
      else
        @membership.invited = true
        @membership.save
        format.turbo_stream { flash.now[:notice] = 'Friend invited!' }
        format.html { redirect_to root_path }
      end
    end
  end

  def request_join
    @user = current_user
    @community.members << @user unless Membership.exists?(member_id: @user.id, community_id: @community.id)
    @membership = Membership.where(member_id: @user.id, community_id: @community.id).first
    @membership.requested = true

    respond_to do |format|
      if @membership.save
        @membership.send_join_request_notification(sender: current_user)
        format.turbo_stream { flash.now[:notice] = 'Requested to join the community!' }
        format.html { redirect_to root_path }
      else
        format.turbo_stream { flash.now[:alert] = 'You already requested to join the community!' }
        format.html { redirect_to root_path }
      end
    end
  end

  def request_unsend
    @membership ||= Membership.find(params[:membership_id] || params[:id])
    @user = current_user
    @membership.requested = false

    respond_to do |format|
      if @membership.save
        @membership.unsend_join_request_notification(sender: current_user)
        format.turbo_stream { flash.now[:notice] = 'Request to join the community removed!' }
        format.html { redirect_to root_path }
      else
        format.turbo_stream { flash.now[:alert] = 'Unable to unsend the request!' }
        format.html { redirect_to root_path }
      end
    end
  end

  def invite
    @user = User.find(params[:user_id])
    @community.members << @user unless Membership.exists?(member_id: @user.id, community_id: @community.id)
    @membership = Membership.where(member_id: @user.id, community_id: @community.id).first

    respond_to do |format|
      if @membership.invited == true
        format.turbo_stream { flash.now[:alert] = 'Already invited!' }
        format.html { redirect_to root_path }
      else
        @membership.invited = true
        @membership.save
        @membership.send_invite_notification(sender: current_user, receiver: @user)
        format.turbo_stream { flash.now[:notice] = 'Friend invited!' }
        format.html { redirect_to root_path }
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
        format.html { redirect_to community_path(@community), status: :unprocessable_entity, alert: 'Unable to add!' }
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
    @membership ||= Membership.find(params[:membership_id] || params[:id])
  end

  def community
    @community ||= if params[:community_id]
                     Community.find(params[:community_id])
                   else
                     @membership.community
                   end
  end
end
