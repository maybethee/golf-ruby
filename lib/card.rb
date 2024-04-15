class Card
  attr_accessor :state
  attr_reader :suit, :rank

  def initialize(suit, rank, state = 'hidden')
    @suit = suit
    @rank = rank
    @state = state
  end
end