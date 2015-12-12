# TODO: Refactor this model to use an internal Game Model instead
# of containing the game logic directly.
class window.App extends Backbone.Model
  initialize: ->
    @set 'deck', deck = new Deck()
    @set 'playerHand', deck.dealPlayer()
    @set 'dealerHand', deck.dealDealer()
   
    player = @get 'playerHand'
    dealer = @get 'dealerHand'

    player.on 'stand', =>
      console.log('stand, appModel')
      @dealerTurn(dealer)
    
    player.on 'add', =>
      console.log('player added, appModel')
      if player.scores()[0] > 21 then @bust(player.isDealer)

    dealer.on 'add', =>
      console.log('dealer added, appModel')
      if dealer.scores()[0] > 21 then @bust(dealer.isDealer)

  bust: (dealerBusts) ->
    if dealerBusts then console.log("Dealer busted! You win!")
    else console.log("You busted! Dealer wins!")

  dealerTurn: (dealer) ->
    console.log('Dealer\'s Turn, appModel')
    while dealer.scores()[1] < 17
      dealer.hit()
      console.log(dealer.scores()[1])
    @countScores()

  countScores: ->
    player = @get 'playerHand'
    dealer = @get 'dealerHand'
    
    if player.bestScore() > dealer.bestScore()
      console.log("Dealer has #{dealer.bestScore()}. You win!")
    
    else
      console.log("Dealer has #{dealer.bestScore()}. You lose!")
    
    #if player.scores[]
    #console.log("You win")
    #console.log("Dealer wins")

