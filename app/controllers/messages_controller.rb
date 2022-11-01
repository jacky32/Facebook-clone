class MessagesController < ApplicationController
  def create
    @message = Message.new(message_params)
    respond_to do |format|
      if @message.save
        @message.broadcast_prepend_later_to "#{@message.chat.id}_messages",
                                            locals: { c_user: current_user, message: @message }
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
    params.require(:message).permit(:body, :user_id, :chat_id)
  end
end
