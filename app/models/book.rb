class Book < ApplicationRecord
  belongs_to :user

  has_many :favorites, dependent: :destroy
  has_many :favorited_users, through: :favorites, source: :user

  has_many :book_comments, dependent: :destroy
  
  has_many :view_counts, dependent: :destroy

  validates :title, presence: true
  validates :body, presence: true, length: { maximum: 200 }
  
  #データの取り出し方を指示
  scope :latest, -> {order(created_at: :desc)}  #latestは任意の名前、orderはデータの取り出し
  scope :old, -> {order(created_at: :asc)}      #created_atは投稿日カラム、descは昇順、ascは降順
  scope :star_count, -> {order(star: :desc)}
  
  # 検索機能
  def self.search_for(content, method)
    if method == 'perfect'
      Book.where(title: content)
    elsif method == 'forward'
      Book.where('title LIKE ?', content+'%')
    elsif method == 'backward'
      Book.where('title LIKE ?', '%'+content)
    else
      Book.where('title LIKE ?', '%'+content+'%')
    end
  end

  def favorited_by?(user)
    favorites.where(user_id: user.id).exists?
  end
end
