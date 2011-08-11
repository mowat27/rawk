require 'spec_helper'
require 'stringio'
 
module Rawk
  describe Program do
    include TestHelpers
         
    context "against n lines of space delimited data" do
      before do
        @data = StringIO.new("a b\nc d\ne f\n")
        @program = Program.new(@data)
      end
            
      it "calculates the record num as nr" do
        record_nums = []
        @program.run do
          start  {record_nums << nr}
          every  {record_nums << nr}
          finish {record_nums << nr}
        end
        record_nums.should == [0,1,2,3,3]
      end
      
      context "when passed code in a string" do      
        it "runs the string as ruby code" do
          code = "every {puts 'foo'}"
          out = capture_stdout { @program.run code }.string
          out.should == "foo\nfoo\nfoo\n"
        end
      end
      
      context "when passed code in ruby blocks" do                        
        it "executes the blocks in order" do
          start_block, every_block, finish_block = lambda {}, lambda {}, lambda {}
          start_block.should_receive(:call).once    
          every_block.should_receive(:call).exactly(3).times        
          finish_block.should_receive(:call).once
        
          @program.run do
            start  &start_block
            every  &every_block
            finish &finish_block
          end
        end
        
        it "includes the scope of the calling program" do
          result = []
          @program.run do 
            every {|l| result << l}
          end
          result.should == ["a b","c d","e f"]
        end        
      end
      
      # Start -----------            
      it "calls each of many start blocks once" do
        block1, block2 = lambda {}, lambda {}
        block1.should_receive(:call).once
        block2.should_receive(:call).once                
        @program.run do
          start &block1                    
          start &block2                    
        end
      end
      it "only calls a duplicate start block once" do
        block = lambda {}
        block.should_receive(:call).once
        @program.run do
          start &block                  
          start &block                    
        end        
      end
    
      # Every -----------      
      it "calls all the every blocks n times with each line of data" do
        block1, block2 = lambda {}, lambda {}
        block1.should_receive(:call).exactly(3).times
        block2.should_receive(:call).exactly(3).times
        @program.run do
          every &block1
          every &block2
        end
      end
    
      it "calls duplicate every blocks only once for each line" do
        block = lambda {}
        block.should_receive(:call).exactly(3).times
        @program.run do
          every &block
          every &block
        end
      end
    
      it "passes each line in turn to the every block" do
        block = lambda {}
        block.should_receive(:call).once.with("a b").ordered
        block.should_receive(:call).once.with("c d").ordered
        block.should_receive(:call).once.with("e f").ordered
        @program.run {every &block}
      end
    
      # Finish -----------      
      it "calls every finish block once" do
        block1, block2 = lambda {}, lambda {}
        block1.should_receive(:call).once
        block2.should_receive(:call).once
        @program.run do
          finish &block1
          finish &block2
        end
      end
      it "calls duplicate finish blocks only once" do
        block = lambda {}
        block.should_receive(:call).once
        @program.run do
          finish &block
          finish &block
        end
      end
    end
  end
end