
class Deck
  attr_accessor :cards, :discard_pile

  def initialize
    @cards = [].tap do |cards|
      %w(♠︎ ♣︎ ♥︎ ♦︎).each do |suit|
        %w(A 2 3 4 5 6 7 8 9 10 J Q K).each do |rank|
          cards << Card.new(suit, rank)
        end
      end
      2.times { cards << Card.new('*', '*') }
    end

    @discard_pile = []
  end

  def deck_size
    @cards.size
  end

  def discard_size
    @discard_pile.size
  end

  def shuffle!
    @cards.shuffle!
    self
  end

  def draw_from_deck!
    @cards.pop
  end

  def draw_from_discard!
    # must draw from top of discard pile (last discarded card)
    @discard_pile.pop
  end

  def show_history
    @discard_pile.each { |c| puts c }
  end
end
