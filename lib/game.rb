require_relative 'player'
require_relative 'deck'
require_relative 'card'
require_relative 'score_calc'
require_relative 'hole'

class Game
  def initialize
    @original_order = [Player.new('Player 1', 'human'), Player.new('Player 2', 'computer')]
    @players = @original_order.dup
  end

  def play
    hole_count = 1
    until hole_count >= 10
      # reset relevant objects when each new round starts
      reset_players
      add_current_hole_to_score_hash(hole_count)
      reset_hands

      # start new round
      current_hole = Hole.new(@players)
      current_hole.play_hole(hole_count)
      hole_count += 1
    end

    # reset players again here to print scores in originl order
    reset_players
    @players.each(&:print_scoreboard)
    call_winner
  end

  def reset_hands
    @players.each(&:reset_hand)
  end

  def reset_players
    @players = @original_order.dup
  end

  def add_current_hole_to_score_hash(hole_number)
    @players.each do |player|
      player.score_hash[hole_number] = nil
    end
  end

  def call_winner
    @players.each(&:sum_total)

    @players.each { |player| puts player.total_score }
    winning_player = @players.min_by(&:total_score)

    puts "\nThe winner is: #{winning_player.name} with #{winning_player.total_score} points!"
  end
end
