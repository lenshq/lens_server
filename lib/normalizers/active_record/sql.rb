module Normalizers::ActiveRecord
  class Sql < Normalizers::Base
    class << self
      def type
        'db.sql.query'
      end

      def normalize(record)
        source = ['SCHEMA', 'CACHE'].include?(record[:name]) ? 'rails' : 'app'

        {
          content: cleanup(PgQuery.normalize(record[:sql])),
          source: source
        }.merge(super)
      end

      private

      def cleanup(query)
        arr = query.split("\n")
        arr = arr.map { |line| line.strip }
        arr.join(' ')
      end
    end
  end
end
