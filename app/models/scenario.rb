# == Schema Information
#
# Table name: scenarios
#
#  id              :integer          not null, primary key
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  events_hash     :string
#  event_source_id :integer
#

class Scenario < ActiveRecord::Base
  belongs_to :event_source
  has_many :requests, dependent: :destroy

  validates :events_hash, presence: true
  validates :events_hash, uniqueness: { scope: [:event_source] }

  def self.hash_from_string(str)
    Digest::MD5.hexdigest(str)
  end
end
