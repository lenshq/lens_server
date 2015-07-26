module Normalizers
  class Base
    class << self
      def normalize(record)
        base_record_details(record)
      end

      protected

      def undefined_type(record)
        record[:etype]
      end

      def base_record_details(record)
        {
          type: begin type rescue(undefined_type(record)) end,
          duration: record[:eduration],
          start: record[:estart],
          finish: record[:efinish]
        }
      end
    end
  end
end
