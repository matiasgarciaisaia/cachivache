require "./cachivache/*"

module Cachivache
  class Cache
    @storage = Hash(String, Entry).new

    def []=(key, value)
      self[key, nil] = value
    end

    def []=(key, expiration, value)
      @storage[key] = Entry.new(value, expiration)
    end

    def [](key)
      @storage[key].value
    end

    struct Entry
      def initialize(@value : String, @expiration : Time?)
      end

      getter value
      getter expiration
    end
  end
end
