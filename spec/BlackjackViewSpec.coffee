expect = chai.expect

describe "player's hand", ->
  deck = null
  hand = null

  beforeEach ->
    deck = new Deck()
    hand = deck.dealPlayer()

  it "should have a stand method", ->
    expect(hand.stand).to.be.a ("function")
