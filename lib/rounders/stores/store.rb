module Rounders
  module Stores
    class Store
      include Rounders::Plugins::Pluggable
      include Topping::Configurable::Branch

      def [](key)
        data[key]
      end

      def []=(key, value)
        data[key] = value
      end

      def data
        raise 'Called abstract method: data'
      end

      class << self
        def inherited(klass)
          super
          Rounders.stores[klass.symbol] = klass
        end
      end
    end
  end
end
