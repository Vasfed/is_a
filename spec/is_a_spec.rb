require 'minitest/autorun'
require 'benchmark'
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

  describe "caller_line" do
    it "in methods" do
      def test_caller
        [caller[0], subject.caller_line(0)]
      end
      r = test_caller
      r.first.must_equal r.last
    end

    it "in blocks" do
      r = proc{
        [caller[0], subject.caller_line(0)]
      }.call
      r.last.wont_be_nil
      r.first.must_equal r.last
    end

    it "should be faster than caller[0]" do
      n = 1000
      anchor = Benchmark.measure{ n.times{ caller[0] } }
      res = Benchmark.measure{ n.times{ subject.caller_line(0) } }
      assert_operator res.total, :<, anchor.total
      assert_operator res.real, :<, anchor.real
      assert_operator res.utime, :<, anchor.utime

      # no large memory allocation => no system cpu time
      res.stime.must_equal 0.0
    end
  end

end
