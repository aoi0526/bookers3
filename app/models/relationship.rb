class Relationship < ApplicationRecord
  belongs_to :following, class_name: 'User' #ユーザーテーブルってことを教えてあげる
  belongs_to :follower, class_name: 'User'
end
