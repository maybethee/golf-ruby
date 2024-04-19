class Player
  attr_accessor :hand, :score_hash, :total_score
  attr_reader :name, :type

  def initialize(name, type)
    @name = name
    @type = type
    @hand = []

    # score_hash's key value pairs should be
    # { hole_number: hole_score }
    @score_hash = {}

    @total_score = 0
  end

  def show_hand
    puts "\n#{@name}'s hand:"
    reshaped_array = @hand.each_slice(3).to_a
    reshaped_array.each do |row|
      puts row.join('|')
    end
    puts
  end

  def reset_hand
    @hand = []
  end

  def all_revealed?
    @hand.all? { |card| card.state != 'hidden' }
  end

  def add_hole_score(current_score)
    # add current score as value to last key in hash
    @score_hash[@score_hash.keys[-1]] = current_score
  end

  def sum_total
    @total_score = @score_hash.values.sum
  end

  def print_scoreboard
    # must only print at end of game to avoid trying to add unassigned nil values
    puts "\n#{@name}'s score's: #{@score_hash}\nTotal score: #{@score_hash.values.sum}"
  end
end
