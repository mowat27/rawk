require 'set'
require 'observer'

module Rawk  
  class Program    
    attr_reader :fs
    
    def initialize(io)
      @start, @every, @finish = Set.new, Set.new, Set.new
      @input_stream = InputStream.new(io)
      @input_stream.add_observer(self)
      initialize_builtins!
    end
    
    private
    def initialize_builtins!
      @fs = " "
      @nr = 0
    end
    
    public
    def on_new_line
      @nr += 1
    end
    alias :update :on_new_line
    
    def run(code = "", &block)
      load!(code, &block)
      execute_code!
    end
    
    # DSL 
    def start(&block)
      @start << block
    end
    
    def every(&block)
      @every << block
    end
    
    def finish(&block)
      @finish << block
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
        @every.each {|b| b.call(Line.new(row, @fs))}
      end
      @finish.each {|b| b.call}
    end
  end
  
  class InputStream
    include Observable
    
    def initialize(io)
      @io = io
    end
    
    def each_line
      @io.each_line do |line| 
        changed
        notify_observers
        yield line
      end
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