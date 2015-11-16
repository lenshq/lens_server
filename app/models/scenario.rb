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

  validates :events_hash, presence: true
  validates :events_hash, uniqueness: { scope: [:event_source] }

  class << self
    def hash_from_string(str)
      Digest::MD5.hexdigest(str)
    end

    def self.in_period
      query = Druid::Query::Builder.new
      query
      .group_by([:scenario])
      .granularity(:all)
      .filter(application: event_source.application.id)
      .filter(event_source: event_source.id)
      .long_sum(:count)

      get(query)
    end

    def datasource
      "broker/#{LensServer.config.druid.datasource.events}"
    end

    def get(query)
      ServiceLocator.druid_client.data_source(datasource).post(query)
    end
  end
end
