module Normalizers
  module ActionController
    class HaltedCallback < Normalizers::Base
      class << self
        def type
          'app.controller.callback'.freeze
        end

        def normalize(record)
          super
        end
      end
    end
  end
end
