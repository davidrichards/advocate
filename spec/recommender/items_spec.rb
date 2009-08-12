require File.join(File.dirname(__FILE__), "/../spec_helper")

describe Items do
  
  before do
    @i = Items.new
  end
  
  it "should be a Dictionary" do
    Items.new.should be_is_a(Dictionary)
  end
  
  it "should require arrays" do
    lambda{@i[:this] = :not_an_array}.should raise_error(ArgumentError, "Can only supply arrays to the items list.")
    lambda{@i[:this] = [1,2,3]}.should_not raise_error
  end
  
  it "should store values in the order they were created" do
    @i[:a] = [1,2,3]
    @i[:b] = [2,3,4]
    @i[:c] = [2,3,3]
    @i.keys.should eql([:a, :b, :c])
  end
  
  it "should be able to convert a data frame to an items list" do
    @df = DataFrame.new(:a, :b, :c)
    @df.add([1,2,3])
    @df.add([4,5,6])
    i = Items.new
    i.import @df
    i.variables.should eql([:a, :b, :c])
  end

  it "should be able to convert a data frame to an items list, even from an empty data frame" do
    @df = DataFrame.new(:a, :b, :c)
    i = Items.new
    i.import @df
    i.variables.should eql([:a, :b, :c])
    i = Items.import(@df)
    i.variables.should eql([:a, :b, :c])
  end
  
  it "should be able to convert a conforming Dictionary (dictionary with array values) to an items list" do
    d = Dictionary.new
    d[:a] = [1,2,3]
    d[:b] = [4,5,5]
    i = Items.new
    i.import(d)
    i.variables.should eql([:a, :b])
    i[:a].should eql([1,2,3])
    i[:b].should eql([4,5,5])
  end
  
  it "should be able to setup an items list variables from an array" do
    i = Items.import([:a, :b, :c])
    i.variables.should eql([:a, :b, :c])
    i[:a].should eql([])
    i[:b].should eql([])
    i[:c].should eql([])
  end

  it "should be able to setup an items list variables from an array" do
    i = Items.import({:a => [1,2,3]})
    i.variables.should eql([:a])
    i[:a].should eql([1,2,3])
  end
end