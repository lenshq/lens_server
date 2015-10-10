class EventSource < ActiveRecord::Base
  belongs_to :application
  has_many :pages, dependent: :destroy
  has_many :events, through: :pages

  validates :application, presence: true
  validates :source, presence: true
  validates :endpoint, presence: true
  validates :application_id, uniqueness: { scope: [:source, :endpoint] }

  def path
    "#{source}##{endpoint}"
  end

  def sum_duration(from: nil, to: nil)
    pages_scope = pages
    pages_scope = pages_scope.where(created_at: from..to) if from && to
    pages_scope.sum(:duration)
  end

  def avg_duration(from: nil, to: nil)
    pages_scope = pages
    pages_scope = pages_scope.where(created_at: from..to) if from && to
    pages_scope.average(:duration).to_f
  end

  def min_duration(from: nil, to: nil)
    pages_scope = pages
    pages_scope = pages_scope.where(created_at: from..to) if from && to
    pages_scope.minimum(:duration).to_f
  end

  def max_duration(from: nil, to: nil)
    pages_scope = pages
    pages_scope = pages_scope.where(created_at: from..to) if from && to
    pages_scope.maximum(:duration).to_f
  end

  def requests_count(from: nil, to: nil)
    if from.present?
      to = Time.now if to.blank?
      pages.where(created_at: from..to).count
    else
      pages_count
    end
  end
end
