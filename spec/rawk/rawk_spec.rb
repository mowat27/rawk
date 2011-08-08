require 'spec_helper'

module Rawk
  describe Program do
    context "when passed n lines of space delimited data" do
      before do
        @data = "a b\nc d\ne f\n"
        @program = Program.new(@data)
      end
      
      it "calls the start block once" do
        start_block = mock("start block")
        start_block.should_receive(:call).once
        @program.run do
          start(start_block)
        end
      end
    end
  end
end