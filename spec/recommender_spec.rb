require File.dirname(__FILE__) + '/spec_helper'

describe "Recommender" do
  
  it "should use JustEnumerableStats" do
    [1,2,3].should be_respond_to(:pearson_correlation)
  end
  
  it "should use facets/dictionary" do
    defined?(Dictionary).should eql('constant')
  end
  
  it "should use OpenStruct" do
    defined?(OpenStruct).should eql('constant')
  end
  
  it "should use DataFrame" do
    defined?(DataFrame).should eql('constant')
  end
end
