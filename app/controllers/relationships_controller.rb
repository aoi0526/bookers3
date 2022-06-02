class RelationshipsController < ApplicationController
  before_action :authenticate_user!
  def create
    following = current_user.relationships.build(follower_id: params[:user_id]) #buildでcurrent_userに紐づいたrelationshipを作成することができる、follewer_idにURLのid(user_id)を格納する
    following.save
    redirect_to request.referrer || root_path #前のページに戻る。前のページがなかった場合root_path
  end

  def destroy
    following = current_user.relationships.find_by(follower_id: params[:user_id])
    following.destroy
    redirect_to request.referrer || root_path
  end
end
