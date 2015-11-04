module Normalizers
  module ActionView
    class RenderCollection < Normalizers::Base
      class << self
        def type
          'app.view.render.collection'.freeze
        end

        def normalize(record)
          super
        end
      end
    end
  end
end
