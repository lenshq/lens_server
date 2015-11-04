module Normalizers
  module ActionController
    class StartProcessing < Normalizers::Base
      class << self
        def type
          'app.controller.action.start'.freeze
        end

        def normalize(record)
          super
        end
      end
    end
  end
end
