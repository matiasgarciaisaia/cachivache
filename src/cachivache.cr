require "./cachivache/*"

module Cachivache
  class Cache
    @storage = Hash(String, Entry).new

    def []=(key, value)
      self[key, nil] = value
    end

    def []=(key, expiration, value)
      return if expiration && (expiration < Time.new)
      @storage[key] = Entry.new(value, expiration)
    end

    def [](key)
      @storage[key].value
    end

    def []?(key)
      if entry = @storage[key]?
        entry.value
      else
        nil
      end
    end

    struct Entry
      def initialize(@value : String, @expiration : Time?)
      end

      getter value
      getter expiration
    end
  end
end
