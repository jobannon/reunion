class Reunion
  attr_reader :name, :activities
  def initialize(name)
    @name = name
    @activities = []
  end

  def add_activity(activity)
    @activities << activity
  end

  def total_cost
    @activities.reduce(0) do |acc, activity|
      acc += activity.total_cost
      acc
    end
  end

  def breakout
    @activities.reduce({}) do |acc, activity|
      acc.merge(activity.owed) do |key, old_value, new_value|
        old_value + new_value
      end
    end
  end

  def summary
    stringtime = ""
    breakout.each do |keyval|
      if keyval.last == breakout[breakout.keys.last]
        stringtime << "#{keyval.first}: #{keyval.last}"
      else
        stringtime << "#{keyval.first}: #{keyval.last}\n"
      end
    end
    stringtime
  end

  def pull_participant_name(activity)
    activity.participants.each do |participant|
      participant.first
    end
  end

  def create_sub_hash(activity)

    {"activity:" => activity.name,
    "payees" => calc_payee(activity),
    "amount" => 0
  }
  end

  def calc_payee(activity)
    ## negativre means that you are owed
    store = activity.owed
    store.reduce([]) do |acc, keyval|
      if acc.last == nil || keyval.last > acc.last
        acc = [keyval]
      end
    end
    binding.pry
  end

  def detailed_breakout
    #hash[person's name ] = array .... array to contain hashes ... 3 keys activity payees amount
    result = activities.reduce({}) do |acc, activity|
      acc[pull_participant_name(activity)] = create_sub_hash(activity)
    end
    binding.pry

  end
end
