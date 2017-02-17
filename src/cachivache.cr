require "./cachivache/*"

module Cachivache
  class Cache
    @storage = Hash(String, String).new

    def []=(key, value)
      @storage[key] = value
    end

    def [](key)
      @storage[key]
    end
  end
end
