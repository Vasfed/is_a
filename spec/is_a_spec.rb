require 'minitest/autorun'
require 'is_a'

describe IsA do

  subject { IsA }

  it 'id_of' do
    obj = Class.new(BasicObject){}.new

    id = subject.id_of(obj)
    assert_equal(obj, ObjectSpace._id2ref(id))
  end

  it "object?" do
    subject.object?(Class.new(BasicObject){}.new).must_equal false
    subject.object?("string is object").must_equal true
  end

  it "caller for regular functions" do
    def test_caller
      [caller[0], subject.caller_line(0)]
    end
    r = test_caller
    r.first.must_equal r.last

    # require 'benchmark'
    # n = 50000
    # class UtilClassWithCallerline
    #   class << self
    #     define_method :caller_line, method(:caller_line)
    #   end
    # end
    # Benchmark.bm(19) do |x|
    #   x.report("caller[1]") { n.times { caller[1] } }
    #   x.report("caller_line") { n.times { caller_line(1) } }
    #   x.report("caller_line in ctx") { n.times { UtilClassWithCallerline.caller_line(1) } }
    # end
  end

  it "caller_line for generic context" do
    subject.caller_line(0).wont_be_nil
    subject.caller_line(0).must_equal caller[0]
  end

end
