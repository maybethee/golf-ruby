require_relative 'player'
require_relative 'deck'

class Game
  def initialize
    @player = Player.new
    @deck = Deck.new
  end

  def play
    round = 1
    until round >= 10
      puts "round #{round} begins"
      round += 1
    end
  end
end
