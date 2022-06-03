class Room < ApplicationRecord
  has_many :chats
  has_many :user_rooms #１つのルームにいるユーザーは２人のためhas_manyになる
end
