require 'set'

module Rawk
  class Program    
    def initialize(input_stream)
      @start, @every, @finish = Set.new, Set.new, Set.new
      @input_stream = input_stream
    end
        
    def start(block)
      @start << block
    end
    
    def every(block)
      @every << block
    end
    
    def finish(block)
      @finish << block
    end
    
    def run(&block)
      instance_eval(&block)
      @start.each {|b| b.call}
      @input_stream.each_line do |line|
        @every.each {|b| b.call}
      end
      @finish.each {|b| b.call}
    end
  end
end