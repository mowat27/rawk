require 'spec_helper'

module Rawk
  describe Program do
    context "when passed n lines of space delimited data" do
      before do
        @data = "a b\nc d\ne f\n"
        @program = Program.new(@data)
      end

      # Start -----------            
      it "calls each of many start blocks once" do
        start_block1 = mock("start block 1")
        start_block2 = mock("start block 2")
        start_block1.should_receive(:call).once
        start_block2.should_receive(:call).once                
        @program.run do
          start(start_block1)                    
          start(start_block2)                    
        end
      end
      it "only calls a duplicate start block once" do
        start_block = mock("start block")
        start_block.should_receive(:call).once
        @program.run do
          start(start_block)                    
          start(start_block)                    
        end        
      end

      # During -----------      
      it "calls all the every blocks n times with each line of data" do
        every1 = mock("every 1")
        every2 = mock("every 2")
        every1.should_receive(:call).exactly(3).times
        every2.should_receive(:call).exactly(3).times
        @program.run do
          every(every1)
          every(every2)
        end
      end
      
      it "calls duplicate every blocks only once for each line" do
        every = mock("every block")
        every.should_receive(:call).exactly(3).times
        @program.run do
          every(every)
          every(every)
        end
      end
    end
  end
end