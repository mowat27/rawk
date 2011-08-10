require 'spec_helper'

module Rawk
  describe Line do
    before do
      @line = Line.new("a b c\n")
    end
    it "is a string" do
      @line.is_a?(String).should be_true
    end
    it "chomps itself on creation" do
      @line.should == "a b c"
    end
    it "finds space-delimited columns" do
      @line.cols.should == ["a","b","c"]
      @line.c.should == @line.cols
    end
  end
end