require 'spec_helper'

module Rawk
  describe Record do
    before do
      @space = " "
      @data = "a b c\n"
      @record = Record.new(@data, @space)
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
    
    context "accessing columns by name" do
      before do
        @record = Record.new("a b c d e f g h i j", @space)
      end
    
      {:first => "a", :second => "b"}.each do |method, expected|
        it "finds the #{method} column value" do
          @record.send(method).should == expected
        end
      end
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
    context "with an explict end of line marker" do
      it "chomps the end of line marker" do
        record = Record.new("a b c.", @space, ".")
        record.should == "a b c"
      end
    end
  end
end