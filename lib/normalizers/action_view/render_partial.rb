module Normalizers::ActionView
  class RenderPartial < Normalizers::Base
    class << self
      def type
        'app.view.render.partial'.freeze
      end

      def normalize(record)
        identifier = record[:identifier].split('/')
        identifier.slice!(0, identifier.index('app'))
        path = identifier.join('/')

        {
          content: path
        }.merge(super)
      end
    end
  end
end
