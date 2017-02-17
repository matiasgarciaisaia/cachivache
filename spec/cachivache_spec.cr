require "./spec_helper"

cache = Cachivache::Cache.new

describe Cachivache do
  Spec.before_each { cache = Cachivache::Cache.new }

  it "stores a value that doesn't expire" do
    cache["key"] = "value"
    cache["key"].should eq("value")
  end

  it "stores a value with expiration date" do
    cache["key", Time.new + 3.years] = "value" # hope the spec doesn't run that fast
    cache["key"].should eq("value")
  end

  it "ignores an already expired value" do
    cache["key", Time.new - 1.second] = "value"
    cache["key"]?.should eq(nil)
  end

  it "raises when accessing an inexsistent key" do
    expect_raises { cache["key"] }
  end

  it "raises when accessing an expired key" do
    cache["key", Time.new - 1.second] = "value"
    expect_raises { cache["key"] }
  end

  it "forgets entries after their expiration time" do
    cache["key", Time.new + 1.second] = "value"
    cache["key"].should eq("value")
    sleep 1
    expect_raises { cache["key"] }
  end

  describe ".entries" do
    it "starts with no entries" do
      cache.entries.should eq(0)
    end

    it "counts stored entries" do
      cache["key1"] = "value"
      cache.entries.should eq(1)

      cache["key2"] = "value"
      cache.entries.should eq(2)

      cache["key1"] = "othervalue"
      cache.entries.should eq(2)
    end

    it "doesn't delete expired entries when counting" do
      cache["key", Time.new + 1.second] = "value"
      cache.entries.should eq(1)
      sleep 1
      cache.entries.should eq(1)
      expect_raises { cache["key"] }
      cache.entries.should eq(0)
    end
  end

  describe ".delete_expired" do
    it "deletes expired entries" do
      cache["key", Time.new + 1.second] = "value"
      cache.entries.should eq(1)

      sleep 1
      cache.entries.should eq(1)
      cache.delete_expired
      cache.entries.should eq(0)
    end

    it "honours given 'now' time" do
      cache["key", Time.new + 1.second] = "value"
      cache.entries.should eq(1)
      cache.delete_expired
      cache.entries.should eq(1)
      cache.delete_expired(Time.new + 1.second)
      cache.entries.should eq(0)
    end

    it "doesn't delete anything if there are no expired entries" do
      cache["key"] = "value"
      cache.entries.should eq(1)
      cache.delete_expired(Time.new + 1.second)
      cache.entries.should eq(1)
    end
  end
end
