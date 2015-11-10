module Normalizers::ActiveRecord
  class Sql < Normalizers::Base
    class << self
      def type
        'db.sql.query'
      end

      def normalize(record)
        source = ['SCHEMA', 'CACHE'].include?(record[:name]) ? 'rails' : 'app'

        sql = record[:sql].dup
        sql.gsub!('`', '"')
        normalized_sql = PgQuery.normalize(sql) rescue sql
        {
          content: cleanup(normalized_sql),
          source: source
        }.merge(super)
      end

      private

      def cleanup(query)
        query.gsub!(', ?', '')
        arr = query.split("\n")
        arr = arr.map { |line| line.strip }
        arr.join(' ')
      end
    end
  end
end
