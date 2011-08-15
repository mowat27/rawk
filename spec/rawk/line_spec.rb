require 'spec_helper'

module Rawk
  describe Record do
    before do
      @fs = " "
      @data = "a b c\n"
      @record = Record.new(@data, @fs)
    end
    it "is a string" do
      @record.is_a?(String).should be_true
    end
    it "chomps itself on creation" do
      @record.should == "a b c"
    end
    it "calculates and array of columns" do
      @record.cols.should == ["a","b","c"]
      @record.c.should == @record.cols
    end
    it "calculates the number of fields" do
      @record.nf.should == 3
    end
    
    context "with a field separator ','" do
      it "splits the line into columns using a comma" do
        record = Record.new("a,b,c d", ",") 
        record.c.should == ["a","b","c d"]
      end
    end
    context "with a regular expression field separator" do
      it "splits the line into columns using the regular expression" do
        record = Record.new("a,b|c", /[,|]/)
        record.c.should == ["a","b","c"]
      end
    end
  end
end