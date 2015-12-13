class window.AppView extends Backbone.View
  template: _.template '
    <button class="hit-button">Hit</button>
    <button class="stand-button">Stand</button>
    <button class="deal-button">Deal</button>
    <div id="message-bar"></div> 
    <div class="player-hand-container"></div>
    <div class="dealer-hand-container"></div>
  '

  events:
    'click .hit-button': -> @model.get('playerHand').hit()
    'click .stand-button': -> @model.get('playerHand').stand()
    'click .deal-button': -> @model.initialize(true)

  initialize: ->
    @render()
    @model.on 'bust', (buster) ->
      if buster == 'player'
        $('#message-bar').html "<h3>You busted!</h3>"
      else
        $('#message-bar').html "<h3>Dealer busted! You win!</h3>"
    @model.on 'game', (dealerScore, winner) ->
      if winner == 'player'
        $('#message-bar').html "<h3>Dealer had #{dealerScore}. You win!</h3>"
      else
        $('#message-bar').html "<h3>Dealer had #{dealerScore}. You lose!</h3>"
    @model.on 'newGame', =>
      @render()

  render: ->
    @$el.children().detach()
    @$el.html @template()
    @$('.player-hand-container').html new HandView(collection: @model.get 'playerHand').el
    @$('.dealer-hand-container').html new HandView(collection: @model.get 'dealerHand').el

