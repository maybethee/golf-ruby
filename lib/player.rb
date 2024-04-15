class Player
  attr_accessor :hand
  attr_reader :name

  def initialize
    @name = 'player'
    @hand = []
  end
end
