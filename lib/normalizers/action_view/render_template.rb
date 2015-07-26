module Normalizers::ActionView
  class RenderTemplate < Normalizers::Base
    class << self
      def type
        'app.view.render.template'.freeze
      end

      def normalize(record)
        identifier = record[:identifier].split('/')
        identifier.slice!(0, identifier.index('app'))
        path = identifier.join('/')

        {
          content: path,
          layout: record[:layout],
        }.merge(super)
      end
    end
  end
end
