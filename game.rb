require_relative 'deck'

class Game

  attr_accessor :player_hand, :dealer_hand, :deck

  def initialize
    self.deck = Deck.new
  end

  def play
    puts "Hi. We're going to play blackjack. Hit [enter] to draw cards."
    STDIN.gets
    # Set up the game
    setup_game
    # Stop game if dealer blackjack
    unless blackjack?(dealer_hand)
      # The player hits or stays
      player_turn
      # The dealer draws until >= 16
      dealer_turn
    end
    # We determine who won and display the result
    determine_winner
    # We ask if we're going to play again
    ask_to_play_again
  end

  def setup_game
    self.player_hand = [deck.draw, deck.draw]
    self.dealer_hand = [deck.draw, deck.draw]
    display_hands
  end

  def display_hands(final=false, player=true)
    if final
      puts "The dealer has #{collect_hand(dealer_hand)}"
    else
      puts "The dealer is showing a #{dealer_hand.first.face} of #{dealer_hand[0].suit}."
    end
    if player
      puts "You have #{collect_hand(player_hand)}."
    end
  end

  def collect_hand(hand)
    hand.collect{|card| "a #{card.face} of #{card.suit}"}.join(" and ")
  end

  def player_turn
    if !blackjack?(player_hand)
      hit_or_stay = "h"
      until hit_or_stay != "h" || busted?(player_hand)
        puts "Would you like to hit (h) or stay (s)?"
        hit_or_stay = STDIN.gets.chomp
        if hit_or_stay == "h"
          player_hand << deck.draw
          unless busted?(player_hand)
            display_hands
          end
        end
      end
    end
  end

  def dealer_turn
    unless blackjack?(player_hand) || busted?(player_hand)
      until hand_value(dealer_hand) >= 16
        dealer_hand << deck.draw
      end
    end
  end

  def blackjack?(hand)
    hand.length == 2 && hand_value(hand) == 21
  end

  def busted?(hand)
    hand_value(hand) > 21
  end

  def hand_value(hand)
    hand.inject(0){|sum, card| sum + card.value}
  end

  def six_cards?(hand)
    hand.length >= 6 && hand_value(hand) <= 21
  end

  def determine_winner
    display_hands(true, !blackjack?(dealer_hand))
    if blackjack?(dealer_hand)
      puts "the dealer got blackjack. you lose. the farm, probably."
    elsif blackjack?(player_hand)
      puts "YOU GOT BLACKJACK! YOU WIN!"
    elsif busted?(player_hand)
      puts "You busted. Waahwaah"
    elsif busted?(dealer_hand)
      puts "THE DEALER BUSTED. THAT FOOL."
    elsif six_cards?(player_hand)
      puts "You lucky dog. You drew #{player_hand.length} cards without busting. YOU WIN!"
    elsif hand_value(player_hand) > hand_value(dealer_hand)
      puts "YOU WON!"
    elsif hand_value(dealer_hand) > hand_value(player_hand)
        puts "the dealer won"
    else
      if player_hand.length > dealer_hand.length
        puts "You drew #{player_hand.length} cards vs. the dealer's #{dealer_hand.length}. YOU WIN!"
      elsif dealer_hand.length > player_hand.length
        puts "You drew #{player_hand.length} cards vs. the dealer's #{dealer_hand.length}. YOU LOSE!"
      else
        puts "You tied. For right now, that means YOU WIN!"
      end
    end
  end

  def ask_to_play_again
    puts "Would you like to press your luck with another game? y/n"
    response = STDIN.gets.chomp
    if response == "y"
      Game.new.play
    else
      exit
    end
  end

end
