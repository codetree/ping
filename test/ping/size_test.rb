require File.dirname(__FILE__) + '/../test_helper.rb'

class Ping::SizeTest < MiniTest::Test
  context "#==" do
    should "compare with integers" do
      size = Ping::Size.new(10)
      assert size == 10
    end

    should "compare with nil" do
      size = Ping::Size.new(10)
      assert !(size == nil)

      size = Ping::Size.new(0)
      assert size == nil

      size = Ping::Size.new(nil)
      assert size == nil
    end

    should "compare with other sizes" do
      size = Ping::Size.new(10)
      assert Ping::Size.new(10) == size
      assert !(Ping::Size.new(11) == size)
    end
  end

  context "#to_s" do
    should "return the points as a string" do
      size = Ping::Size.new(10)
      assert_equal "10", size.to_s
    end
  end

  context "#to_i" do
    should "return the integer points" do
      size = Ping::Size.new(10)
      assert_equal 10, size.to_i
    end
  end
end
