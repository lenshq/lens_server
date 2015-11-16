module Test
  module Poseidon
    class Producer
      attr_reader :messages

      def initialize(*)
        @messages = []
      end

      def send_messages(*args)
        @messages.push(args)
      end

      def clear
        @messages.clear
      end
    end
  end
end
