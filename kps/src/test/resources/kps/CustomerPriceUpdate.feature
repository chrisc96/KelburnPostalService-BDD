Feature: Testing price changes for customers

  # Testing price change specification event

  # Notification of a price change to KPS customers. Relevant
  # data includes: the origin and destination locations that the price change affects,
  # the mail priority this price is applicable to, along with the new price per gram and
  # new price per cubic centimeter that will be charged to customers.

  Scenario Outline: Executing a customer price change for an existing route
    Given an initial customer price map
    And I want to change the pricing of a direct customer route
    And that route comes from "<FromCity>", "<FromCountry>"
    And that route goes to "<ToCity>", "<ToCountry>"
    And that route is being sent by "<Priority Type>" priority
    Given the customer parcel is being sent from "New Zealand"
    Given this direct pricing route exists
    Then store the old prices
    Then store the new prices where the newPricePerCC is <NewPricePerCC> and the newPricePerGram is <NewPricePerGram>
    Then apply the new prices to the system
    Then try to get the new customer pricing route
    Then check the old customer route doesn't exist anymore
    Examples:
      | FromCity      | FromCountry | ToCity         | ToCountry   | Priority Type     | NewPricePerCC | NewPricePerGram |
      | Auckland      | New Zealand | Singapore City | Singapore   | international air | 28000          | 32000           |
      | Auckland      | New Zealand | Napier         | New Zealand | domestic standard | 4000           | 6000            |
      | Auckland      | New Zealand | Wellington     | New Zealand | domestic standard | 4000           | 6000            |
      | Auckland      | New Zealand | Wellington     | New Zealand | domestic air      | 10000          | 8500            |
      | Dunedin       | New Zealand | Wellington     | New Zealand | domestic air      | 10000          | 8500            |
      | Dunedin       | New Zealand | Wellington     | New Zealand | domestic standard | 7000           | 6000            |
      | Invercargill  | New Zealand | Auckland       | New Zealand | domestic standard | 7000           | 5500            |
      | Nelson        | New Zealand | Wellington     | New Zealand | domestic standard | 2000           | 3000            |
      | Wellington    | New Zealand | Auckland       | New Zealand | domestic standard | 4000           | 6000            |
      | Wellington    | New Zealand | Auckland       | New Zealand | domestic air      | 4000           | 6000            |


    Scenario Outline: Test we can send mail with correct pricing costs after customer price is updated
      Given an initial customer price map
      And I want to change the pricing of a direct customer route
      And that route comes from "<FromCity>", "<FromCountry>"
      And that route goes to "<ToCity>", "<ToCountry>"
      And that route is being sent by "<Priority Type>" priority
      Given the customer parcel is being sent from "New Zealand"
      Given this direct pricing route exists
      Given I want to send a parcel with a weight of <Weight>kg
      Given I want to send a parcel with a volume of <Measurement>cc
      Then store the new prices where the newPricePerCC is <NewPricePerCC> and the newPricePerGram is <NewPricePerGram>
      Then apply the new prices to the system
      And try send the mail and check if the route used is correct
      Examples:
        | FromCity      | FromCountry | ToCity          | ToCountry   | Priority Type     | NewPricePerCC | NewPricePerGram | Weight  | Measurement |
        | Auckland      | New Zealand | Singapore City | Singapore   | international air | 28000          | 32000           | 182     | 85000       |
        | Auckland      | New Zealand | Napier         | New Zealand | domestic standard | 4000           | 6000            | 52      | 180000      |
        | Auckland      | New Zealand | Wellington     | New Zealand | domestic standard | 4000           | 6000            | 37      | 21000       |
        | Auckland      | New Zealand | Wellington     | New Zealand | domestic air      | 10000          | 8500            | 43      | 108000      |
        | Dunedin       | New Zealand | Wellington     | New Zealand | domestic air      | 10000          | 8500            | 34      | 184000      |
        | Dunedin       | New Zealand | Wellington     | New Zealand | domestic standard | 7000           | 6000            | 71      | 2000        |
        | Invercargill  | New Zealand | Auckland       | New Zealand | domestic standard | 7000           | 5500            | 15      | 24000       |
        | Nelson        | New Zealand | Wellington     | New Zealand | domestic standard | 2000           | 3000            | 183     | 99000       |
        | Wellington    | New Zealand | Auckland       | New Zealand | domestic standard | 4000           | 6000            | 104     | 98000       |
        | Wellington    | New Zealand | Auckland       | New Zealand | domestic air      | 4000           | 6000            | 92      | 148000      |
