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

    deal
  end

  def deal
    puts 'shuffling deck'
    @deck.shuffle!

    puts 'dealing your cards'
    6.times do
      @player.hand << @deck.draw!
    end

    puts 'revealing 2 cards'
    reveal_two_cards
    @player.hand.each { |c| puts c }
  end

  def reveal_two_cards
    revealed_cards = @player.hand.sample(2)
    revealed_cards.each do |card|
      card.state = 'revealed'
    end
  end
end
