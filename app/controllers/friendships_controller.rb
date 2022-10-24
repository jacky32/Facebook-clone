class FriendshipsController < ApplicationController
  def accept_request
    @friend_request = Friendship.find(params[:friendship_id])
    @friend_request.accepted = true
    @friend_request.save
  end

  def update
    @friendship = Friendship.find(params[:id])
    pp @friendship
    @friendship.accepted = true
    respond_to do |format|
      if @friendship.save
        format.turbo_stream { flash.now[:notice] = 'Friendship established!' }
      else
        format.turbo_stream { flash.now[:alert] = 'Unable to establish the friendship!' }
      end
    end
  end
end
