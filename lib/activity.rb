require 'pry'
class Activity

  attr_reader :name, :participants

  def initialize(name)
   @name = name
   @participants = {}
  end

  def add_participant(name, total_cost)
    @participants[name] = total_cost
    # @participants = (name => total_cost)
  end

  def total_cost
    @participants.values.sum
  end

  def split
    total_participants = @participants.size
    total_cost / total_participants
  end

  def owed
    # @participants.map do |key, value|
    #   binding.pry
    # end
    result = @participants.reduce({}) do |acc, (key, val)|
      update = split - val
      acc[key] = update
      acc
    end
  end
end
