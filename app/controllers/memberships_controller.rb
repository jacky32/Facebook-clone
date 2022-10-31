class MembershipsController < ApplicationController
  # before_action :friendship, only: %i[update destroy]
  # before_action :user, only: %i[create update destroy]

  # def accept_request
  #   @friend_request = Friendship.find(params[:friendship_id])
  #   @friend_request.accepted = true
  #   @friend_request.save
  # end

  # def create
  #   current_user_id = params[:user_id]
  #   if current_user.friend_request_received?(user_id: @user.id)
  #     @friendship = Friendship.where(user_id: @user.id, friend_id: current_user_id).first
  #     @friendship.accepted = true
  #   else
  #     @friendship = Friendship.new(user_id: current_user_id, friend_id: @user.id)
  #   end
  #   respond_to do |format|
  #     if @friendship.save
  #       format.turbo_stream { flash.now[:notice] = 'Friend request sent!' }
  #     else
  #       format.turbo_stream { flash.now[:alert] = 'Unable to send the friend request!' }
  #     end
  #   end
  # end

  def update
    @membership = Membership.find(params[:id])
    @community = @membership.community
    @membership.confirmed_by_admin = true
    respond_to do |format|
      if @membership.save
        format.html { redirect_to root_path, notice: 'Member added!' }
        format.turbo_stream { flash.now[:notice] = 'Member added!' }
      else
        format.html do
          redirect_to root_path, status: :unprocessable_entity, alert: 'Unable to add the member!'
        end
        format.turbo_stream { flash.now[:alert] = 'Unable to add the member!' }
      end
    end
  end

  # def destroy
  #   respond_to do |format|
  #     if @friendship.destroy
  #       format.html { redirect_to root_path, notice: 'Membership deleted!' }
  #       format.turbo_stream { flash.now[:notice] = 'Membership deleted!' }
  #     else
  #       format.html { redirect_to root_path, status: :unprocessable_entity, alert: 'Unable to delete the membership!' }
  #       format.turbo_stream { flash.now[:alert] = 'Unable to delete the membership!' }
  #     end
  #   end
  # end

  # def user
  #   @user ||= User.find(params[:friend_id]) if params[:friend_id]
  # end
end
