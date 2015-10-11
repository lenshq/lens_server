module Normalizers::ActionView
  class RenderTemplate < Normalizers::Base
    class << self
      def type
        'app.view.render.template'.freeze
      end

      def normalize(record)
        path = case record[:identifier]
               when "text template"
                 "text template"
               else
                 identifier = record[:identifier].split('/')
                 identifier.slice!(0, identifier.index('app'))
                 identifier.join('/')
               end

        {
          content: path,
          layout: record[:layout],
        }.merge(super)
      end
    end
  end
end
