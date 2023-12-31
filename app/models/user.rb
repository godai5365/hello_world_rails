class User < ApplicationRecord
  validates :account, presence: true, uniqueness: { case_sensitive: false }
  has_many :articles

  has_many :user_detail

  has_many :user_communities
  has_many :communities, through: :user_communities

  # validates :account, presence: true, uniqueness: { case_sensitive: false }
end
