module Normalizers::NetHttp
  class Request < Normalizers::Base
    class << self
      def type
        'ruby.net.request'.freeze
      end

      def normalize(record)
        super
      end
    end
  end
end
