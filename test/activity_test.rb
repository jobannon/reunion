require 'minitest'
require 'minitest/autorun'
require 'minitest/pride'
require_relative "./../lib/activity"
require 'pry'

class ActivityTest < Minitest::Test

  def setup
    @activity1 = Activity.new("Brunch")
  end

  def test_it_exists
    assert_instance_of Activity, @activity1
  end

  def test_attributes
    assert_equal "Brunch", @activity1.name
    empty = {}
    assert_equal empty, @activity1.participants
  end

  def test_particants_can_be_added
    @activity1.add_participant("Maria", 20)
    expected = {"Maria" => 20}
    assert_equal expected, @activity1.participants
    expected2 = {"Maria" => 20, "Luther" => 40}
    @activity1.add_participant("Luther", 40)
    assert_equal expected2, @activity1.participants
  end

  def test_it_can_calculate_total_cost
    @activity1.add_participant("Maria", 20)
    @activity1.add_participant("Luther", 40)
    assert_equal 60, @activity1.total_cost
  end

  def test_it_can_split_the_cost
    @activity1.add_participant("Maria", 20)
    @activity1.add_participant("Luther", 40)
    assert_equal 30, @activity1.split
  end

  def test_it_can_owe
    @activity1.add_participant("Maria", 20)
    @activity1.add_participant("Luther", 40)
    expected = {"Maria" => 10, "Luther" => -10}
    assert_equal expected, @activity1.owed
  end
end
