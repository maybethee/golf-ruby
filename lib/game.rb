require_relative 'player'
require_relative 'deck'
require_relative 'card'


class Game
  def initialize
    @player = Player.new
    @deck = Deck.new
  end

  def play
    hole = 1
    # until hole >= 10
      play_hole(hole)
      # hole += 1
    # end
  end

  def play_hole(hole)
    puts "hole #{hole} begins"
  end
end
