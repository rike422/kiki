module Rounders
  module Matchers
    class To < Rounders::Matchers::Matcher
      attr_reader :pattern

      def initialize(pattern)
        @pattern = pattern
      end

      def match(message)
        return if message.to.nil?
        matches = message.to.map do |address|
          address.match(pattern)
        end
        matches.compact
      end
    end
  end
end
