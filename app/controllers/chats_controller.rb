class ChatsController < ApplicationController
  before_action :user, only: :create

  def show
    if params[:id]
      @chat = Chat.find(params[:id])
      @messages = @chat.messages
      @user = @chat.sender == current_user ? @chat.receiver : @chat.sender
    else
      @user = User.find(params[:user_id])
      @messages = Message.retrieve(current_user, @user)
    end
    render formats: :turbo_stream, template: 'chats/chat', locals: { user: @user, chat: @chat }
  end

  def show_recent_chat
    @chat = Chat.find(params[:id])
    render formats: :turbo_stream, template: 'chats/show'
  end

  def create
    decide_chat(current_user, @user)
    @messages = @chat.messages

    respond_to do |format|
      if @chat.save
        current_user.set_last_chat_active(@chat)
        format.turbo_stream { render 'chats/chat' }
      else
        format.turbo_stream { flash.now[:alert] = 'Unable' }
      end
    end
  end

  private

  def user
    @user ||= User.find(params[:user_id])
  end

  def decide_chat(user1, user2)
    @chat ||= if Chat.exists?(user1, user2)
                Chat.retrieve(user1, user2)
              else
                Chat.new(sender_id: user1.id, receiver_id: user2.id)
              end
  end
end
