require 'spec_helper'

module Rawk
  describe Line do
    before do
      @fs = " "
      @data = "a b c\n"
      @line = Line.new(@data, @fs)
    end
    it "is a string" do
      @line.is_a?(String).should be_true
    end
    it "chomps itself on creation" do
      @line.should == "a b c"
    end
    it "finds space-delimited columns by" do
      @line.cols.should == ["a","b","c"]
      @line.c.should == @line.cols
    end
    it "calculates the number of fields" do
      @line.nf.should == 3
    end
    
    context "with a field separator ','" do
      it "splits the line into columns using a comma" do
        line = Line.new("a,b,c d", ",") 
        line.c.should == ["a","b","c d"]
      end
    end
    context "with a regular expression field separator" do
      it "splits the line into columns using the regular expression" do
        line = Line.new("a,b|c", /[,|]/)
        line.c.should == ["a","b","c"]
      end
    end
  end
end