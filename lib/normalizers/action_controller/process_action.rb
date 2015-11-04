module Normalizers
  module ActionController
    class ProcessAction < Normalizers::Base
      class << self
        def type
          'app.controller.action.finish'.freeze
        end

        def normalize(record)
          super
        end
      end
    end
  end
end
