class Normalizers::ActionController
  class RedirectTo < Normalizers::Base
    class << self
      def type
        'app.controller.redirect'.freeze
      end

      def normalize(record)
        super
      end
    end
  end
end
