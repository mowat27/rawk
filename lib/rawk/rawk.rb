require 'set'
require 'observer'

module Rawk  
  class Program    
    attr_reader :fs, :rs
    
    def initialize(io)
      @start, @every, @finish = Set.new, Set.new, Set.new
      initialize_builtins!
      @input_stream = InputStream.new(io)
      @input_stream.add_observer(self)
    end
    
    private
    def initialize_builtins!
      @fs = " "
      @nr = 0
      @rs = "\n"
    end
    
    public
    def on_new_line
      @nr += 1
    end
    alias :update :on_new_line # required by Observer
    
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
      @input_stream.each_line(@rs) do |str|
        record = Record.new(str, @fs, @rs)
        @every.each {|b| b.call(record)}
      end
      @finish.each {|b| b.call}
    end
  end
  
  class InputStream
    include Observable
    
    def initialize(io)
      @io = io
    end
    
    def each_line(separator)
      @io.each_line(separator) do |line| 
        changed
        notify_observers
        yield line
      end
    end
  end
  
  class Record < String    
    def self.column_postion_accessor(name, position)
      define_method(name.to_sym) do
        cols[position]
      end
    end
    
    def initialize(str, fs, eor = "\n")
      self.replace(str.chomp(eor))
      @fs = fs
    end
    
    def cols
      split(@fs)
    end
    alias :c :cols
    
    def nf 
      cols.length
    end
    
    {:first => 0,:second => 1, :third => 2, :fourth => 3,:fifth => 4,
     :sixth => 5,:seventh => 6,:eighth => 7,:ninth => 8, :tenth => 9
     }.each do |name, column_position|
      column_postion_accessor name, column_position
    end
  end
end