require_relative 'player'
require_relative 'deck'
require_relative 'card'
require_relative 'score_calc'
require_relative 'hole'

class Game
  def initialize
    @original_order = [Player.new('Player 1', 'human'), Player.new('Player 2', 'computer')]
    @players = @original_order.dup
    # @current_player = @players.first
    # @deck = Deck.new
  end

  def play
    hole_count = 1
    until hole_count >= 10
      reset_players
      reset_hands
      current_hole = Hole.new(@players)
      current_hole.play_hole(hole_count)
      # play_hole(hole_count)
      hole_count += 1
    end
  end

  def reset_hands
    @players.each(&:reset_hand)
  end

  def reset_players
    @players = @original_order.dup
    # @current_player = @players.first
  end
end
