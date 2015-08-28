class EventSourceSerializer < ActiveModel::Serializer
  attributes :id, :source, :endpoint, :avg_duration, :sum_duration, :pages_count

  def as_json
    {
      id: id,
      path: "#{source}##{endpoint}",
      source: source,
      endpoint: endpoint,
      duration: avg_duration.to_f,
      time: sum_duration.to_f,
      count: pages_count
    }
  end
end
