class Card

  attr_accessor :face, :value, :suit

  def initialize(face, suit)
    self.face = face
    self.suit = suit
    if ["King", "Queen", "Jack"].include?(face)
      self.value = 10
    elsif face == "Ace"
      self.value = 11
    else
      self.value = face.to_i
    end
  end

end
