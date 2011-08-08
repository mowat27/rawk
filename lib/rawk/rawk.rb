module Rawk
  class Program
    def initialize(input_stream)
      @start = []
    end
    
    def start(block)
      @start << block unless @start.include? block
    end
    
    def run(&block)
      instance_eval(&block)
      @start.each {|b| b.call}
    end
  end
end