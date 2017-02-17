require "./spec_helper"

describe Cachivache do
  cache = Cachivache::Cache.new

  it "stores a value that doesn't expire" do
    cache["key"] = "value"
    cache["key"].should eq("value")
  end
end
