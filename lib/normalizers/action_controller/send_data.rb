module Normalizers
  module ActionController
    class SendData < Normalizers::Base
      class << self
        def type
          'app.controller.send_data'.freeze
        end

        def normalize(record)
          super
        end
      end
    end
  end
end
