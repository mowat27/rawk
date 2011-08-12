require 'set'

module Rawk
  class Program    
    def initialize(input_stream)
      @start, @every, @finish = Set.new, Set.new, Set.new
      @input_stream = input_stream
      @fs = " "
    end
    
    attr_reader :fs
    def set_fs=(value)
      @fs = value
    end
    
    def nr 
      @input_stream.lineno
    end
               
    def start(&block)
      @start << block
    end
    
    def every(&block)
      @every << block
    end
    
    def finish(&block)
      @finish << block
    end
    
    def run(code = "", &block)
      load!(code, &block)
      execute_code!
    end
    
    private 
    def load!(code, &block)
      if code.empty?
        instance_eval(&block) 
      else
        instance_eval(code)
      end
    end
    
    def execute_code!
      @start.each {|b| b.call}
      @input_stream.each_line do |row|
        @every.each {|b| b.call(Line.new(row, fs))}
      end
      @finish.each {|b| b.call}
    end
  end
  
  class Line < String
    def initialize(str, fs)
      self.replace(str.chomp)
      @fs = fs
    end
    
    def cols
      split(@fs)
    end
    alias :c :cols
    
    def nf 
      cols.length
    end
  end
end