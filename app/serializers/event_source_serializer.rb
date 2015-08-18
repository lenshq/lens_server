class EventSourceSerializer < ActiveModel::Serializer
  attributes :id, :source, :endpoint, :avg_duration, :sum_duration, :pages_count
end
