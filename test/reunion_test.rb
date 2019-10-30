require 'minitest'
require 'minitest/autorun'
require 'minitest/pride'
require_relative "./../lib/activity"
require 'pry'
require_relative './../lib/reunion'

class ReunionTest < Minitest::Test
  def setup
    @reunion1 = Reunion.new("1406 BE")
  end

  def test_it_exists
    assert_instance_of Reunion, @reunion1
  end

  def test_it_has_attributes
    assert_equal "1406 BE", @reunion1.name
    assert_equal [], @reunion1.activities
  end

  def test_it_can_add_activities
    activity_1 = Activity.new("Brunch")
    @reunion1.add_activity(activity_1)
    assert_equal [activity_1], @reunion1.activities
  end

  def test_total_cost
    activity_1 = Activity.new("Brunch")
    activity_1.add_participant("Maria", 20)
    activity_1.add_participant("Luther", 40)
    @reunion1.add_activity(activity_1)
    assert_equal 60,@reunion1.total_cost

    activity_2 = Activity.new("Drinks")
    activity_2.add_participant("Maria", 60)
    activity_2.add_participant("Luther", 60)
    activity_2.add_participant("Louis", 0)
    @reunion1.add_activity(activity_2)
    assert_equal 180, @reunion1.total_cost
  end

  def test_breakout
    activity_1 = Activity.new("Brunch")
    activity_1.add_participant("Maria", 20)
    activity_1.add_participant("Luther", 40)
    @reunion1.add_activity(activity_1)

    activity_2 = Activity.new("Drinks")
    activity_2.add_participant("Maria", 60)
    activity_2.add_participant("Luther", 60)
    activity_2.add_participant("Louis", 0)
    @reunion1.add_activity(activity_2)

    expected = {"Maria" => -10, "Luther" => -30, "Louis" => 40}
    assert_equal expected, @reunion1.breakout
  end

  def test_summary
    activity_1 = Activity.new("Brunch")
    activity_1.add_participant("Maria", 20)
    activity_1.add_participant("Luther", 40)
    @reunion1.add_activity(activity_1)

    activity_2 = Activity.new("Drinks")
    activity_2.add_participant("Maria", 60)
    activity_2.add_participant("Luther", 60)
    activity_2.add_participant("Louis", 0)
    @reunion1.add_activity(activity_2)

    expected = "Maria: -10\nLuther: -30\nLouis: 40"
    assert_equal expected, @reunion1.summary
  end

  def test_detailed_breakout
    # One person owes one person
    activity_1 = Activity.new("Brunch")
    activity_1.add_participant("Maria", 20)
    activity_1.add_participant("Luther", 40)

# One person owes two people
    activity_2 = Activity.new("Drinks")
    activity_2.add_participant("Maria", 60)
    activity_2.add_participant("Luther", 60)
    activity_2.add_participant("Louis", 0)

# Two people owe one person
    activity_3 = Activity.new("Bowling")
    activity_3.add_participant("Maria", 0)
    activity_3.add_participant("Luther", 0)
    activity_3.add_participant("Louis", 30)

# Two people owe two people
    activity_4 = Activity.new("Jet Skiing")
    activity_4.add_participant("Maria", 0)
    activity_4.add_participant("Luther", 0)
    activity_4.add_participant("Louis", 40)
    activity_4.add_participant("Nemo", 40)

    @reunion1.add_activity(activity_1)
    @reunion1.add_activity(activity_2)
    @reunion1.add_activity(activity_3)
    @reunion1.add_activity(activity_4)
    #name   
    expected = {
      "Maria" => [
        {
          activity: "Brunch",
          payees: ["Luther"],
          amount: 10
        },
        {
          activity: "Drinks",
          payees: ["Louis"],
          amount: -20
        },
        {
          activity: "Bowling",
          payees: ["Louis"],
          amount: 10
        },
        {
          activity: "Jet Skiing",
          payees: ["Louis", "Nemo"],
          amount: 10
        }
      ],
    "Luther" => [
      {
        activity: "Brunch",
        payees: ["Maria"],
        amount: -10
      },
      {
        activity: "Drinks",
        payees: ["Louis"],
        amount: -20
      },
      {
        activity: "Bowling",
        payees: ["Louis"],
        amount: 10
      },
      {
        activity: "Jet Skiing",
        payees: ["Louis", "Nemo"],
        amount: 10
      }
    ],
    "Louis" => [
      {
        activity: "Drinks",
        payees: ["Maria", "Luther"],
        amount: 20
      },
      {
        activity: "Bowling",
        payees: ["Maria", "Luther"],
        amount: -10
      },
      {
        activity: "Jet Skiing",
        payees: ["Maria", "Luther"],
        amount: -10
      }
    ],
    "Nemo" => [
      {
        activity: "Jet Skiing",
        payees: ["Maria", "Luther"],
        amount: -10
    }
  ]
}

    @reunion1.detailed_breakout
  end
end
