# TODO: Refactor this model to use an internal Game Model instead
# of containing the game logic directly.
class window.App extends Backbone.Model
  initialize: (newGame) ->
    if !newGame then @set 'deck', deck = new Deck()
    else deck = @get 'deck'
    @set 'playerHand', deck.dealPlayer()
    @set 'dealerHand', deck.dealDealer()
    @trigger 'newGame'
    playerMoney = @get 'playerMoney'
    playerMoney ||= 500
    @set 'playerMoney', playerMoney-10
    @trigger 'money'

    player = @get 'playerHand'
    dealer = @get 'dealerHand'
    that = @

    player.on 'stand', =>
      @dealerTurn(dealer)
    
    player.on 'add', =>
      if player.scores()[0] > 21 then @bust(player.isDealer)

    dealer.on 'add', =>
      if dealer.scores()[0] > 21 then @bust(dealer.isDealer)
      else _.delay ->
            that.dealerTurn(dealer)
          , 1000

  bust: (dealerBusts) ->
    player = @get 'playerHand'
    if dealerBusts 
      @trigger('bust', 'dealer')
      playerMoney = @get 'playerMoney'
      if player.bestScore() == 21
        @set 'playerMoney', playerMoney+15
      else
        @set 'playerMoney', playerMoney+10
      @trigger 'money'
    else 
      @trigger('bust', 'player')
    @gameOver(true)

  dealerTurn: (dealer) ->
    if dealer.scores()[2] > 0 and dealer.scores()[2] < 17
      dealer.hit()
    else @gameOver()
  
  gameOver: (param) ->
    if !param then @countScores()
    dealer = @get 'dealerHand'
    dealer.reveal()

  countScores: ->
    player = @get 'playerHand'
    playerMoney = @get 'playerMoney'
    dealer = @get 'dealerHand'

    if player.bestScore() > dealer.bestScore()
      @trigger('game', dealer.bestScore(),'player')
      if player.bestScore() == 21
        @set 'playerMoney', playerMoney+15
      else
        @set 'playerMoney', playerMoney+10
      @trigger 'money'
    else
      @trigger('game', dealer.bestScore(),'dealer')

