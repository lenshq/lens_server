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

  has_many :scenarios, dependent: :destroy

  validates :application, presence: true
  validates :source, presence: true
  validates :endpoint, presence: true
  validates :application_id, uniqueness: { scope: [:source, :endpoint] }

  def requests
  end

  def events
  end

  def path
    "#{source}##{endpoint}"
  end

  def sum_duration(from: nil, to: nil)
    Request.sum_duration(event_source: self, from: from, to: to)
  end

  def avg_duration(from: nil, to: nil)
    Request.avg_duration(event_source: self, from: from, to: to)
  end

  def requests_count(from: nil, to: nil)
    Request.count(event_source: self, from: from, to: to)
  end
end
