PROJECT_DIR=File.expand_path(File.dirname(__FILE__), '..')
$: << File.join(PROJECT_DIR, 'lib')

require 'rawk/rawk'

module Rawk::TestHelpers
  def capture_stdout
    out = StringIO.new
    $stdout = out
    yield
    return out
  ensure
    $stdout = STDOUT
  end
end