module Normalizers
  module ActionController
    class WriteFragment < Normalizers::Base
      class << self
        def type
          'app.cache.write.fragment'.freeze
        end

        def normalize(record)
          super
        end
      end
    end
  end
end
