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
    puts "hole #{hole} begins\n\n"

    deal
    arrange_draw_options

    loop do

      puts "draw from where? (enter 1 or 2)\n\n(1)\n|--|\n|??|\n|--|\n\n(2)\n|--|\n|#{@deck.discard_pile.last}|\n|--|\n"

      if draw_decision == '1'
        # method swap from eck
        swap_from_deck
      else
        # method swap from discard
        swap_from_discard
      end

      # next_player method
      # ...

      # break if current_player.hand.all_revealed?
    end
  end

  def deal
    puts 'shuffling deck'
    @deck.shuffle!

    puts 'dealing your cards'
    6.times do
      @player.hand << @deck.draw_from_deck!
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

  def arrange_draw_options
    puts "arranging options...\n\n"

    @deck.discard_pile << @deck.draw_from_deck!
    @deck.discard_pile.last.reveal
  end

  # gets user input on which pile to draw/swap from
  def draw_decision
    loop do
      error_message = "Invalid input.\n\n"
      choice = gets.chomp.strip.downcase[0]
      return choice if valid_draw_choice?(choice)

      puts error_message
    end
  end

  # gets user input on which card from hand to swap with chosen pile-card
  # discard option is available as long as argument = 1
  def swap_decision(discard_option)
    loop do
      error_message = "Invalid input.\n\n"
      choice = gets.chomp.strip.downcase[0]
      return choice if valid_swap_choice?(choice, discard_option)

      puts error_message
    end
  end

  def swap_from_deck
    # when a draw from deck is chosen, top card is revealed
    @deck.cards.last.reveal

    # player is prompted to swap with a card in their hand or to discard the revealed card
    puts "\n|--|\n|#{@deck.cards.last}|\n|--|\n\n"
    puts 'enter swap location, or type discard to discard:'
    @player.show_hand
    puts

    swap_location = swap_decision(1)
    if swap_location == 'd'
      # discard
      @deck.discard_pile << @deck.draw_from_deck!
    else
      # swap deck.cards.last with card in swap_decision position
      puts 'before swap'
      @player.show_hand
      puts
      swap_with_hand(@deck.draw_from_deck!, swap_location.to_i - 1)
      puts 'after swap'
      @player.show_hand
      puts
    end
  end

  def swap_with_hand(card_to_swap, hand_position)
    # reveal card if hidden
    @player.hand[hand_position].reveal

    # add chosen card from hand to discard pile
    @deck.discard_pile << @player.hand[hand_position]

    # add last in discard pile (top card irl) to player's hand
    @player.hand[hand_position] = card_to_swap
    puts "discarded: #{@deck.discard_pile.last}\n\n"
  end

  def swap_from_discard
    # when swapping from discard, player only needs to decide which card in their hand to swap with top card of discard pile
    puts 'before swap'
    @player.show_hand
    puts
    puts "which card to swap?"
    swap_with_hand(@deck.draw_from_discard!, swap_decision(2).to_i - 1)
    puts 'after swap'
    @player.show_hand
    puts
  end

  def valid_draw_choice?(choice)
    %w[1 2].include?(choice)
  end

  def valid_swap_choice?(choice, discard_option)
    if discard_option != 1
      %w[1 2 3 4 5 6].include?(choice)
    else
      %w[1 2 3 4 5 6 d].include?(choice)
    end
  end
end
