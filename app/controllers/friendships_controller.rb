class FriendshipsController < ApplicationController
  before_action :authenticate_user!
  before_action :friendship, only: %i[update destroy]
  before_action :user, only: %i[create update destroy]

  def accept_request
    @friend_request = Friendship.find(params[:friendship_id])
    @friend_request.accepted = true
    @friend_request.save
  end

  def show
    @friendship = Friendship.find(params[:id])
    @friend = @friendship.user == current_user ? User.find(@friendship.friend_id) : @friendship.user
    render formats: :turbo_stream, template: 'friendships/show'
  end

  def create
    current_user_id = params[:user_id]
    if current_user.friend_request_received?(user_id: @user.id)
      @friendship = Friendship.where(user_id: @user.id, friend_id: current_user_id).first
      @friendship.accepted = true
    else
      @friendship = Friendship.new(user_id: current_user_id, friend_id: @user.id)
    end
    respond_to do |format|
      if @friendship.save
        format.turbo_stream { flash.now[:notice] = 'Friend request sent!' }
        format.html { redirect_to root_path }
      else
        format.turbo_stream { flash.now[:alert] = 'Unable to send the friend request!' }
        format.html { redirect_to root_path }
      end
    end
  end

  def update
    @friendship.accepted = true
    respond_to do |format|
      if @friendship.save
        format.html { redirect_to root_path, notice: 'Friendship established!' }
        format.turbo_stream { flash.now[:notice] = 'Friendship established!' }
      else
        format.html do
          redirect_to root_path, status: :unprocessable_entity, alert: 'Unable to establish the friendship!'
        end
        format.turbo_stream { flash.now[:alert] = 'Unable to establish the friendship!' }
      end
    end
  end

  def destroy
    respond_to do |format|
      if @friendship.destroy
        format.html { redirect_to root_path, notice: 'Friendship deleted!' }
        format.turbo_stream { flash.now[:notice] = 'Friendship deleted!' }
      else
        format.html { redirect_to root_path, status: :unprocessable_entity, alert: 'Unable to delete the friendship!' }
        format.turbo_stream { flash.now[:alert] = 'Unable to delete the friendship!' }
      end
    end
  end

  private

  def user
    @user ||= User.find(params[:friend_id]) if params[:friend_id]
  end

  def friendship
    @friendship ||= Friendship.find(params[:id])
  end
end
