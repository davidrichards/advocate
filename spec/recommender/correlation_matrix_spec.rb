require File.join(File.dirname(__FILE__), "/../spec_helper")

describe CorrelationMatrix do
  
  before do 
    @i = Items.new
    @i[:a] = [1,2,3]
    @i[:b] = [2,3,3]
    @i[:c] = [3,3,3.1]
    @cm = CM.new(@i)
    @dict = Dictionary.new
    @dict[:a] = [1,2,3]
    @dict[:b] = [3,2,1]
  end 
  
  it "should take a list of items" do
    lambda{CorrelationMatrix.new(:not_items)}.should raise_error(ArgumentError, "Must supply an items dictionary.")
    lambda{CorrelationMatrix.new(@i)}.should_not raise_error
  end
  
  it "should offer the variables (labels)" do
    @cm.variables.should eql([:a, :b, :c])
    @cm.labels.should eql([:a, :b, :c])
  end
  
  it "should offer the items as a shortcut" do
    @cm.items.should eql(@i)
  end
  
  it "should offer the correlation in an array of arrays, a simple matrix" do
    @cm.matrix.should be_is_a(Array)
    @cm.matrix.all? do |row|
      row.should be_is_a(Array)
    end
  end
  
  it "should calculate the Pearson's correlation between all pairs in the matrix" do
    pc = @i[:a].pearson_correlation(@i[:b])
    @cm.matrix[0][1].should eql(pc)
    @cm.matrix[1][0].should eql(pc)
  end
  
  it "should have a lookup by variable name" do
    a = @cm.a
    a.should be_is_a(OpenStruct)
    a.b.should eql(@cm.matrix[0][1])
    v = a.values
    v.should be_include(@cm.matrix[0][1])
    v.should be_include(@cm.matrix[0][2])
    v.size.should eql(2)
  end
  
  it "should have a knn method that returns an ordered dictionary of up to k items" do
    dict = @cm.a.knn(5)
    dict.should be_is_a(Dictionary)
    dict.size.should eql(2) # Because there are only two values that are not a 
    dict.keys.should eql([:c, :b])

    dict = @cm.a.knn(1)
    dict.size.should eql(1)
    dict.keys.should eql([:c])
  end

  it "should be able to import data for the items dictionary" do
    cm = CM.import(@dict)
    cm.variables.should eql([:a, :b])
  end
  
  it "should be able to produce a filtered correlation (negative and NaN) values appear as 0" do
    @cm = CM.import(@dict)
    @cm.a.knn(3, true)[:b].should eql(0)
  end
  
  it "should play nicely with empty data sets" do
    lambda{ CM.import [:a, :b, :c] }.should_not raise_error
  end
end