require_relative 'card'

class Deck

  attr_accessor :cards

  def initialize
    self.cards = []
    possible_suits = %w(Clubs Diamonds Spades Hearts)
    possible_faces = %w(2 3 4 5 6 7 8 9 10 Jack Queen King Ace)
    possible_suits.each do |suit|
      possible_faces.each do |face|
        cards << Card.new(face, suit)
      end
    end
    shuffle
  end

  def shuffle
    self.cards = cards.shuffle
  end

  def draw
    cards.shift
  end

end
