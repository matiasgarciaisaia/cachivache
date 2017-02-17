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
end
