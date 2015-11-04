module Normalizers
  module ActionMailer
    class Deliver < Normalizers::Base
      class << self
        def type
          'app.mailer.deliver'.freeze
        end

        def normalize(record)
          super
        end
      end
    end
  end
end
