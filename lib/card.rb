class Card
  attr_accessor :state
  attr_reader :suit, :rank

  def initialize(suit, rank, state = 'hidden')
    @suit = suit
    @rank = rank
    @state = state
  end

  def to_s
    if @state == 'hidden'
      '??'
    else
      "#{@rank}#{@suit}"
    end
  end

  def reveal
    @state = 'revealed'
  end

  def hidden?
    @state == 'hidden'
  end
end
