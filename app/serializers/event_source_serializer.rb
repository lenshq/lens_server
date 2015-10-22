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

class EventSourceSerializer < ActiveModel::Serializer
  attributes :id, :path, :source, :endpoint

  attribute :avg_duration, key: :duration
  attribute :sum_duration, key: :time
  attribute :requests_count, key: :count

  has_many :requests
end
