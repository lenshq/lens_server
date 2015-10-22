# == Schema Information
#
# Table name: applications
#
#  id          :integer          not null, primary key
#  title       :string           not null
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  token       :string           not null
#  domain      :string
#

class ApplicationSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :token

  has_many :event_sources
end
