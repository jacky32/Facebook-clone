class MessagesController < ApplicationController
  def chat
    @user = User.find(params[:user_id])
    @messages = Message.retrieve(current_user, @user)
    respond_to do |format|
      format.turbo_stream do
        render 'messages/chat'
      end
    end
  end

  def create
    @message = Message.new(message_params)
    respond_to do |format|
      if @message.save
        format.html { redirect_to root_path, notice: 'Message sent! ' }
        format.turbo_stream { flash.now[:notice] = 'Message sent!' }
      else
        format.html { redirect_to root_path, status: :unprocessable_entity, alert: 'Message was not sent!' }
        format.turbo_stream { flash.now[:alert] = 'Message was not sent!' }
      end
    end
  end

  private

  def message_params
    params.require(:message).permit(:body, :sender_id, :receiver_id)
  end
end
