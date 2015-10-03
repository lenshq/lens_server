class EventSourceSerializer < ActiveModel::Serializer
  attributes :id, :path, :source, :endpoint, :duration, :time, :pages_count

  has_many :pages
end
