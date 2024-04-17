require_relative 'player'
require_relative 'deck'
require_relative 'card'
require_relative 'score_calc'

class Game
  RANK_CONVERSION = { 'A': 1, '2': 2, '3': 3, '4': 4, '5': 5, '6': 6, '7': 7, '8': 8, '9': 9, '10': 10, 'J': 10, 'Q': 10, 'K': 0, '*': -2 }.freeze

  def initialize
    @players = [Player.new('Player 1', 'human'), Player.new('Player 2', 'computer')]
    @current_player = @players.first
    @deck = Deck.new
  end

  def play
    hole = 1
    until hole >= 10
      play_hole(hole)
      hole += 1
    end
  end

  def play_hole(hole)
    puts "hole #{hole} begins\n\n"

    deal
    arrange_draw_options
    hole_turn_loop

    puts "round over!\n\nhole #{hole} scores:"

    reveal_all_cards
    hole_scores
  end

  def hole_turn_loop
    loop do
      display_player_turn_prompt

      if @current_player.type == 'human'
        human_turn
      else
        computer_turn
      end

      break if @current_player.all_revealed?

      # next_player method if round continues
      player_next
    end
  end

  def deal
    puts 'shuffling deck'
    @deck.shuffle!
    puts 'dealing your cards'

    # iterate through array of players to deal each 6 cards and reveal 2
    @players.each do |player|
      6.times { player.hand << @deck.draw_from_deck! }
      reveal_two_cards(player)

      player.show_hand
    end
  end

  def reveal_two_cards(player)
    revealed_cards = player.hand.sample(2)
    revealed_cards.each do |card|
      card.state = 'revealed'
    end
  end

  def arrange_draw_options
    @deck.discard_pile << @deck.draw_from_deck!
    @deck.discard_pile.last.reveal
  end

  def display_player_turn_prompt
    puts "\n#{@current_player.name}, choose where to draw from? (1 or 2)\n\n"
    @current_player.show_hand
    puts "\n(1) deck\n┏━━━┓\n┃?? \n┗━━━┛\n\n(2) discard pile\n┏━━━┓\n┃#{@deck.discard_pile.last}\n┗━━━┛\n"
  end

  def human_turn
    if draw_decision == '1'
      # method swap from deck
      swap_from_deck
    else
      # method swap from discard
      swap_from_discard
    end
  end

  def computer_turn
    # if discard pile card < 6, swap with random hidden card
    if RANK_CONVERSION.fetch(@deck.discard_pile.last.rank.to_sym) < 6
      # swap with random hidden card in hand
      swap_with_hand(@deck.draw_from_discard!, random_hidden_card)
      puts "#{@current_player.name} drew from discard"
    else
      # else, draw from deck
      @deck.cards.last.reveal
      # check again if card < 6
      if RANK_CONVERSION.fetch(@deck.cards.last.rank.to_sym) < 6
        swap_with_hand(@deck.draw_from_deck!, random_hidden_card)
        puts "#{@current_player.name} drew from deck"
      else
        # discard if computer can't find card < 6
        @deck.discard_pile << @deck.draw_from_deck!
        puts "#{@current_player.name} discarded drawn card"
      end
    end
    @current_player.show_hand
  end

  def random_hidden_card
    # array of indeces satisfying condition of being hidden
    indices = @current_player.hand.each_index.select { |card| @current_player.hand[card].state == 'hidden' }

    # return random index from that array
    indices.sample
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

  def swap_prompt
    puts "\n┏━━━┓\n┃#{@deck.cards.last}\n┗━━━┛\n"
    puts "which card to swap (1-6), or type 'discard' to discard:"
    @current_player.show_hand
    puts
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
    swap_prompt

    swap_location = swap_decision(1)
    if swap_location == 'd'
      # discard
      @deck.discard_pile << @deck.draw_from_deck!
    else
      # swap deck.cards.last with card in swap_decision position
      @current_player.show_hand
      # swap_location becomes equivalent hand index after - 1
      swap_with_hand(@deck.draw_from_deck!, swap_location.to_i - 1)
      @current_player.show_hand
    end
  end

  def swap_with_hand(card_to_swap, hand_position)
    # reveal card if hidden
    @current_player.hand[hand_position].reveal

    # add chosen card from hand to discard pile
    @deck.discard_pile << @current_player.hand[hand_position]

    # add last in discard pile (top card irl) to player's hand
    @current_player.hand[hand_position] = card_to_swap
    puts "discarded: #{@deck.discard_pile.last}\n\n"
  end

  def swap_from_discard
    # when swapping from discard, player only needs to decide which card in their hand to swap with top card of discard pile
    puts 'which card to swap?'
    @current_player.show_hand
    puts
    swap_with_hand(@deck.draw_from_discard!, swap_decision(2).to_i - 1)
    @current_player.show_hand
    puts
  end

  def reveal_all_cards
    @players.each do |player|
      player.hand.each(&:reveal)
      player.show_hand
    end
  end

  def hole_scores
    @players.each do |player|
      player_score = ScoreCalculator.new(player.hand)
      hole_score = player_score.calculate
      puts "\n#{player.name}: #{hole_score} points"
      # Scoreboard.add_hole_score(player, hole_score)
    end
  end

  def player_next
    @current_player = @players.rotate!.first
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
