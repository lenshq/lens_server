class EventSource < ActiveRecord::Base
  belongs_to :application
  has_many :pages
  has_many :events, through: :pages

  validates :application, presence: true
  validates :source, presence: true
  validates :endpoint, presence: true
  validates :application_id, uniqueness: { scope: [:source, :endpoint] }

  def sum_duration
    pages.sum(:duration)
  end

  def avg_duration
    pages.average(:duration)
  end

  def min_duration
    pages.minimum(:duration)
  end

  def max_duration
    pages.maximum(:duration)
  end
end
