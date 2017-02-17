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
      check_expiration(key)
      @storage[key].value
    end

    def []?(key)
      check_expiration(key)
      if entry = @storage[key]?
        entry.value
      else
        nil
      end
    end

    def check_expiration(key, now = Time.new)
      if entry = @storage[key]?
        @storage.delete(key) if entry.expired? now
      end
    end

    def entries
      @storage.size
    end

    struct Entry
      def initialize(@value : String, @expiration : Time?)
      end

      getter value
      getter expiration

      def expired?(now = Time.new)
        if expiration = @expiration
          expiration <= now
        else
          false
        end
      end
    end
  end
end
