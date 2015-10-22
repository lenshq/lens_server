# == Schema Information
#
# Table name: event_sources
#
#  id             :integer          not null, primary key
#  application_id :integer
#  source         :string
#  endpoint       :string
#  pages_count    :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class EventSource < ActiveRecord::Base
  belongs_to :application

  has_many :requests, dependent: :destroy
  has_many :events, through: :requests
  has_many :scenarios, dependent: :destroy

  validates :application, presence: true
  validates :source, presence: true
  validates :endpoint, presence: true
  validates :application_id, uniqueness: { scope: [:source, :endpoint] }

  def path
    "#{source}##{endpoint}"
  end

  def sum_duration(from: nil, to: nil)
    requests_scope = requests
    requests_scope = requests_scope.where(created_at: from..to) if from && to
    requests_scope.sum(:duration)
  end

  def avg_duration(from: nil, to: nil)
    requests_scope = requests
    requests_scope = requests_scope.where(created_at: from..to) if from && to
    requests_scope.average(:duration).to_f
  end

  def min_duration(from: nil, to: nil)
    requests_scope = requests
    requests_scope = requests_scope.where(created_at: from..to) if from && to
    requests_scope.minimum(:duration).to_f
  end

  def max_duration(from: nil, to: nil)
    requests_scope = requests
    requests_scope = requests_scope.where(created_at: from..to) if from && to
    requests_scope.maximum(:duration).to_f
  end

  def requests_count(from: nil, to: nil)
    if from.present?
      to = Time.now if to.blank?
      requests.where(created_at: from..to).count
    else
      requests_count
    end
  end
end
