class Player
  attr_accessor :hand
  attr_reader :name, :type

  def initialize(name, type)
    @name = name
    @type = type
    @hand = []
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
end
