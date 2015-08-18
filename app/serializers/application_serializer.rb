class ApplicationSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :token
end
