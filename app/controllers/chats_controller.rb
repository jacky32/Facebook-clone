class ChatsController < ApplicationController
  def chat
    @user = User.find(params[:user_id])
    @messages = Message.retrieve(current_user, @user)
    respond_to do |format|
      format.turbo_stream do
        render 'chats/chat'
      end
    end
  end

  def create
    @user = User.find(params[:user_id])
    decide_chat(current_user, @user)
    @messages = @chat.messages

    respond_to do |format|
      if @chat.save
        format.turbo_stream do
          render 'chats/chat'
        end
      else
        format.turbo_stream { flash.now[:alert] = 'Unable' }
      end
    end
  end

  private

  def decide_chat(user1, user2)
    @chat = if Chat.exists?(user1, user2)
              Chat.retrieve(user1, user2)
            else
              Chat.new(sender_id: user1.id, receiver_id: user2.id)
            end
  end
end
