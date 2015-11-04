module Normalizers
  module ActionController
    class ReadFragment < Normalizers::Base
      class << self
        def type
          'app.cache.read.fragment'.freeze
        end

        def normalize(record)
          {
            content: record[:key]
          }.merge(super)
        end
      end
    end
  end
end
