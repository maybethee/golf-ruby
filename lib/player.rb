class Player
  attr_accessor :hand
  attr_reader :name, :type

  def initialize(name, type)
    @name = name
    @type = type
    @hand = []
  end

  def show_hand
    reshaped_array = @hand.each_slice(3).to_a
    reshaped_array.each do |row|
      puts row.join('|')
    end
  end
end
