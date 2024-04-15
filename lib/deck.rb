
class Deck
  attr_accessor :cards

  def initialize
    @cards = [].tap do |cards|
      %w(♠︎ ♣︎ ♥︎ ♦︎).each do |suit|
        %w(A 2 3 4 5 6 7 8 9 10 J Q K).each do |rank|
          cards << Card.new(suit, rank)
        end
      end
      2.times { cards << Card.new('*', 'Joker') }
    end
  end

  def shuffle!
    @cards.shuffle!
  end
end
