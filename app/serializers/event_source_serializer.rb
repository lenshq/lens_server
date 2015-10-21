class EventSourceSerializer < ActiveModel::Serializer
  attributes :id, :path, :source, :endpoint

  attribute :avg_duration, key: :duration
  attribute :sum_duration, key: :time
  attribute :requests_count, key: :count

  has_many :requests
end
