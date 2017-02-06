class MessagesController < ApplicationController

  before_action :set_chat_group_info, only: %i[index create]

  def index
    @chat_groups = current_user.chat_groups
    @message = Message.new
    @messages = @chat_group.messages
    respond_to do |format|
      format.html
      format.json
    end
  end

  def create
    @message = Message.new(message_params)
    if @message.save
      respond_to do |format|
        format.html { redirect_to chat_group_messages_path(@chat_group) }
        format.json
      end
    else
      flash[:alert] = "メッセージが入力されていません。"
      redirect_to chat_group_messages_path(@chat_group)
    end
  end

  private
  def message_params
    params.require(:message).permit(:body, :image).merge(chat_group_id: @chat_group.id, user_id: current_user.id)
  end

  def set_chat_group_info
    @chat_group = ChatGroup.find(params[:chat_group_id])
    @users = @chat_group.users
  end
end
