module Normalizers::ActiveRecord
  class Sql < Normalizers::Base
    class << self
      def type
        'db.sql.query'
      end

      def normalize(record)
        source = ['SCHEMA', 'CACHE'].include?(record[:name]) ? 'rails' : 'app'

        {
          content: PgQuery.normalize(record[:sql]),
          source: source
        }.merge(super)
      end
    end
  end
end
