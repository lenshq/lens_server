class EventSource < ActiveRecord::Base
  belongs_to :application
  has_many :pages
  has_many :events, through: :pages

  validates :application, presence: true
  validates :source, presence: true
  validates :endpoint, presence: true
  validates :application_id, uniqueness: { scope: [:source, :endpoint] }
end
