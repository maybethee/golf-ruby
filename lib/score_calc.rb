class ScoreCalculator
  RANK_CONVERSION = { 'A': 1, '2': 2, '3': 3, '4': 4, '5': 5, '6': 6, '7': 7, '8': 8, '9': 9, '10': 10, 'J': 10, 'Q': 10, 'K': 0, '*': -2 }.freeze

  def initialize(hand)
    @hand = hand
  end

  def calculate
    # convert hand array into something easier to work with?
    scoring_array = @hand.map(&:rank)
    # check if any columns cancel out
    check_columns(scoring_array)
    # convert card ranks to scoring amounts
    convert_rank_to_scores!(scoring_array)
    # sum remaining cards and return total
    scoring_array.sum
  end

  def check_columns(array)
    # shared column index pairs
    column_pairs = [[0, 3], [1, 4], [2, 5]]

    column_pairs.each do |pair|
      # ignore jokers which do not cancel out
      if array[pair[0]] == array[pair[1]] && array[pair[0]] != '*'
        # column score cancels out (convert to K to be compatible with conversion hash)
        array[pair[0]] = 'K'
        array[pair[1]] = 'K'
      end
      next
    end
  end

  def convert_rank_to_scores!(array)
    array.map! do |score|
      RANK_CONVERSION.fetch(score.to_sym)
    end
  end
end
