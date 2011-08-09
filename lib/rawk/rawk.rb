module Rawk
  class Program
    def initialize(input_stream)
      @start, @every = [], []
      @input_stream = input_stream
    end
    
    def start(block)
      @start << block unless @start.include? block
    end
    
    def every(block)
      @every << block unless @every.include? block
    end
    
    def run(&block)
      instance_eval(&block)
      @start.each {|b| b.call}
      @input_stream.each_line do |line|
        @every.each {|b| b.call}
      end
    end
  end
end