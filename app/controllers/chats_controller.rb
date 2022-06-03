class ChatsController < ApplicationController
  before_action :reject_non_related, only: [:show]
  def show
    @user = User.find(params[:id])
    @chat = @user.chats
    rooms = current_user.user_rooms.pluck(:room_id)
    user_room = UserRoom.find_by(user_id: @user.id, room_id: rooms)

    unless user_room.nil?
      @room = user_room.room
    else
      @room = Room.new
      @room.save
      UserRoom.create(user_id: current_user.id, room_id: @room.id)
      UserRoom.create(user_id: @user.id, room_id: @room.id)
    end
    @chats = @room.chats
    @chat = Chat.new(room_id: @room.id)
  end
  def create
    @chat = current_user.chats.new(chat_params)
    render :validater unless @chat.save
  end

  private

  def chat_params
    params.require(:chat).permit(:message, :room_id)
  end

  def reject_non_related
    user = User.find(params[:id])
    unless current_user.is_followed_by?(user) && user.is_followed_by?(current_user)
      redirect_to books_path
    end
  end
end
