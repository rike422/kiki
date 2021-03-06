module Rounders
  module Matchers
    include Topping::Configurable::Branch

    class NoImplementError < StandardError
    end
    class Matcher
      include Rounders::Plugins::Pluggable

      attr_reader :matchers

      def initialize(matchers)
        @matchers = matchers
      end

      def match(message)
        match_data = matchers.each_with_object({}) do |matcher, memo|
          memo[matcher.class.symbol] = matcher.match(message)
        end
        return match_data if match_data.values.none? { |value| Util.blank?(value) }
        nil
      end

      class << self
        def inherited(klass)
          super
          Rounders.matchers[klass.symbol] = klass
        end

        def build(conditions)
          matchers = conditions.map do |key, pattern|
            matcher = Rounders.matchers[key]
            raise Rounders::Matchers::NoImplementError if matcher.nil?
            matcher.new(pattern)
          end
          new(matchers)
        rescue StandardError => e
          raise e
        end
      end
    end
  end
end
