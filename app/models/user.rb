class User < ApplicationRecord
  # デフォルトのDeviseモジュールを含めます。その他の利用可能なモジュールは次のとおりです:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :validatable,
         :omniauthable,
         omniauth_providers: [ :google_oauth2 ]

  validates :email, presence: true, uniqueness: true
  validates :name, presence: true
  validates :uid, presence: true, uniqueness: { scope: :provider }, if: -> { uid.present? }

  has_many :spots, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :favorite_to_spots, through: :favorites, source: :spot

  enum :role, { general: 0, admin: 1, super_admin: 2 }

  # 誰がお気に入り登録をするのか -> Userがお気に入り登録をする為、Userモデルに書く必要がある。
  def favorite(spot)
    favorite_to_spots << spot
  end

  def unfavorite(spot)
    favorite_to_spots.destroy(spot)
  end

  def favorite?(spot)
    favorite_to_spots.include?(spot)
  end

  def own?(spot)
    spot.user_id == self.id
  end

  # providerとuidを使ってユーザーを検索し、存在しなければ新規作成。
  def self.from_omniauth(auth)
    user = where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.name = auth.info.name
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
    end

    # デバッグ：エラーが出た時にどのようなエラーが出るか確認。
    if user.save
      Rails.logger.debug "User saved: #{user.inspect}"
    else
      Rails.logger.debug "User save failed: #{user.errors.full_messages}"
    end

    user
  end

  def self.create_unique_string
    SecureRandom.uuid
  end
end
