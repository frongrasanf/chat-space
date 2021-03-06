class ChatGroupsController < ApplicationController

  before_action :set_chat_group, only: %i[edit update]

  def index
    @chat_groups = current_user.chat_groups
  end

  def new
    @chat_group = ChatGroup.new
  end

  def create
    @chat_group = ChatGroup.new(chat_group_params)
    if @chat_group.save
      redirect_to chat_group_messages_path(@chat_group), notice: 'チャットグループが作成されました。'
    else
      flash[:alert] = '保存に失敗しました。'
      render :new
    end
  end

  def edit
    @users = all_users_without_current_user
    @listed_users = chat_group_users
  end

  def update
    if @chat_group.update(chat_group_params)
      redirect_to chat_group_messages_path(@chat_group), notice: 'チャットグループが更新されました。'
    else
      flash[:alert] = '保存に失敗しました。'
      render :edit
    end
  end

  private
  def chat_group_params
    params.require(:chat_group).permit(:name, user_ids: [])
  end

  def set_chat_group
    @chat_group = ChatGroup.find(params[:id])
  end
end

