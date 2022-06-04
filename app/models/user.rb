class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :books,dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :book_comments, dependent: :destroy

# フォロー機能アソシエーション
  has_many :relationships, foreign_key: :following_id #フォローする側からのhas_many
  has_many :followings, through: :relationships, source: :follower  #あるユーザーがフォローしている人、followingsの部分の名前はなんでも可

  has_many :reverse_of_relastionships, class_name: 'Relationship', foreign_key: :follower_id #重複してしまうのでreverse_of_を使う
  has_many :followers, through: :reverse_of_relastionships, source: :following # あるユーザーをフォローしてくれている人

# DM機能アソシエーション
  has_many :user_rooms, dependent: :destroy
  has_many :chats, dependent: :destroy

# ViewCountアソシエーション
  has_many :view_counts, dependent: :destroy

# グループ機能
  has_many :group_users
  has_many :groups, through: :group_users #userは、group_usersという中間テーブルを通じてgroupsにアクセスできる

  has_one_attached :profile_image

  validates :name, length: { minimum: 2, maximum: 20 }, uniqueness: true
  validates :introduction, length: { maximum: 50 }

  # 検索機能
  def self.search_for(content, method)
    if method == 'perfect'
      User.where(name: content)
    elsif method == 'forward'
      User.where('name LIKE ?', content + '%')
    elsif method == 'backward'
      User.where('name LIKE ?', '%' + content)
    else
      User.where('name LIKE ?', '%' + content + '%')
    end
  end


  def get_profile_image
    (profile_image.attached?) ? profile_image : 'no-image.jpeg'
  end

  def favorited_by?(book_id)
    favorites.where(book_id: book.id).exists?
  end

  def is_followed_by?(user) #あるユーザーがあるユーザにフォローされているか否か
    reverse_of_relastionships.find_by(following_id: user.id).present?
  end
end
