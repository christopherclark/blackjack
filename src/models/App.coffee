# TODO: Refactor this model to use an internal Game Model instead
# of containing the game logic directly.
class window.App extends Backbone.Model
  initialize: (newGame) ->
    if !newGame then @set 'deck', deck = new Deck()
    else deck = @get 'deck'
    @set 'playerHand', deck.dealPlayer()
    @set 'dealerHand', deck.dealDealer()
    @trigger 'newGame'

    player = @get 'playerHand'
    dealer = @get 'dealerHand'
    that = @

    player.on 'stand', =>
      console.log('stand, appModel')
      @dealerTurn(dealer)
    
    player.on 'add', =>
      console.log('player added, appModel')
      if player.scores()[0] > 21 then @bust(player.isDealer)

    dealer.on 'add', =>
      console.log('dealer added, appModel')
      if dealer.scores()[0] > 21 then @bust(dealer.isDealer)
      else _.delay ->
            that.dealerTurn(dealer)
          , 1000

  bust: (dealerBusts) ->
    if dealerBusts then @trigger('bust', 'dealer')
    else @trigger('bust', 'player')
    @gameOver(true)

  dealerTurn: (dealer) ->
    console.log('Dealer\'s Turn, appModel')
    console.log(dealer.scores()[2])
    if dealer.scores()[2] > 0 and dealer.scores()[2] < 17
      dealer.hit()
    else @gameOver()
  
  gameOver: (param) ->
    if !param then @countScores()
    console.log 'gameOver'
    dealer = @get 'dealerHand'
    dealer.reveal()

  countScores: ->
    player = @get 'playerHand'
    dealer = @get 'dealerHand'

    if player.bestScore() > dealer.bestScore()
      @trigger('game', dealer.bestScore(),'player')
    else
      @trigger('game', dealer.bestScore(),'dealer')

