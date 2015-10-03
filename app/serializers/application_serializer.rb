class ApplicationSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :token

  has_many :event_sources
end
