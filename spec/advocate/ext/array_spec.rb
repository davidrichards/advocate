require File.join(File.dirname(__FILE__), "/../../spec_helper")

describe Array do

  before do
    @a = [5,18,9,1,8]
    @reverse = lambda{|a, b| b<=>a}
  end
  
  it "should find the best k elements" do
    @a.best_k(2).should eql([1,5])
    @a.best_k(4).should eql([1,5,8,9])
    @a.best_k(100).should eql(@a.sort)
  end
  
  it "should be able to use an alternate sorting algorithm" do
    @a.best_k(3, &@reverse).should eql([18,9,8])
  end
  
  it "should be able to get the indexes for the best_k" do
    @a.indexes_for_best_k(2).should eql([3,0])
    @a.indexes_for_best_k(3).should eql([3,0,4])
  end
  
  it "should be able to get the indexes for the best_k with an alternate sorting algorithm" do
    @a.indexes_for_best_k(3, &@reverse).should eql([1,2,4])
  end
  
  it "should be able to find all the indexes for a value or block, but not both" do
    a = [0,1,1,1,2]
    a.find_indexes(1).should eql([1,2,3])
    ret = a.find_indexes {|e| e == 1}
    ret.should eql([1,2,3])
    ret = a.find_indexes(1) {|e| e == 2}
    ret.should eql([1,2,3])
    a.find_indices(1).should eql([1,2,3])
  end
  
  it "should be able to place a value in a sorted list without stretching the length of the list" do
    @a.sort!
    @a.place!(0)
    @a.should eql([0,1,5,8,9])
  end
  
  it "should be able to use an alternate sorting algorithm for place!" do
    @a.sort!(&@reverse)
    @a.place!(25, &@reverse)
    @a.place!(14, &@reverse)
    @a.place!(2, &@reverse)
    @a.should eql([25,18,14,9,8])
  end
end
