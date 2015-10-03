class EventSourceSerializer < ActiveModel::Serializer
  attributes :id, :path, :source, :endpoint, :duration, :time, :pages_count

  has_many :pages

  def as_json
    {
      id: id,
      path: "#{source}##{endpoint}",
      source: source,
      endpoint: endpoint,
      duration: duration,
      time: time,
      count: pages_count
    }
  end
end
