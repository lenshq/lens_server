class EventSource < ActiveRecord::Base
  belongs_to :application
  has_many :pages
  has_many :events, through: :pages

  validates :application, presence: true
  validates :source, presence: true
  validates :endpoint, presence: true
  validates :application_id, uniqueness: { scope: [:source, :endpoint] }

  def path
    "#{source}##{endpoint}"
  end

  def sum_duration
    pages.sum(:duration)
  end
  alias_method :time, :sum_duration

  def avg_duration
    pages.average(:duration).to_f
  end
  alias_method :duration, :avg_duration

  def min_duration
    pages.minimum(:duration).to_f
  end

  def max_duration
    pages.maximum(:duration).to_f
  end
end
