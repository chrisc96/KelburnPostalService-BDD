Feature: Customer Prices

  # WARNING.  THE SPECIFICATION HAS SO MANY CONTRADICTIONS FOR CUSTOMER PRICING. HALF OF THESE TESTS
  #           WONT EVER PASS BECAUSE OF THESE TESTING CONTRADICTIONS.


  #  To quote the specification:
  #    'The price customers are charged is based on priority, volume, weight, and destination.'
  #     That is, we alter the priority, volume, weight or destination then the expected price should change.
  #
  #    'New Zealand domestic destinations are considered the same for the purposes of charging the customer.'
  #     Scratching what I said above, if we alter the priority, volume and weight, then the expected price should change.
  #
  #   Hence, this indicates that given the same weight, volume and priority, the price the customer pays should be
  #   irrelevant of where its being sent from/to in New Zealand
  Scenario Outline: Test customer charged same price for shipping domestically irrelevant of origin or destination
    # I created a bunch of <prices> in the data.xml, domestic air was 15 for weightcost and volumecost. domestic standard was 5 for each.
    Given an initial customer map
    Given a customer parcel that weighs <Weight>kg
    Given a customer parcel that measures <Measurement>cc
    And I send the customer parcel from "<FromCity>" "<FromCountry>"
    And I send the customer parcel to "<ToCity>" "<ToCountry>"
    And I send the customer parcel by "<Priority>"
    Given the parcel is sent only within New Zealand
    Then this parcel costs the customer $<ExpectedCost>
    Examples:
    # Standardised weight, measurements and expected costs.
      | Weight | Measurement | Priority           | ExpectedCost  | FromCity     | FromCountry | ToCity      | ToCountry   |
      |   5    |    1250     | domestic air       | 75            | Auckland     | New Zealand | Wellington  | New Zealand |
      |   5    |    1250     | domestic air       | 75            | Wellington   | New Zealand | Auckland    | New Zealand |
      |   5    |    1250     | domestic air       | 75            | Dunedin      | New Zealand | Wellington  | New Zealand |
      |   5    |    1250     | domestic air       | 75            | Wellington   | New Zealand | Dunedin     | New Zealand |

      |   5    |    1250     | domestic standard  | 25            | Auckland     | New Zealand | Wellington  | New Zealand |
      |   5    |    1250     | domestic standard  | 25            | Wellington   | New Zealand | Auckland    | New Zealand |
      |   5    |    1250     | domestic standard  | 25            | Nelson       | New Zealand | Wellington  | New Zealand |
      |   5    |    1250     | domestic standard  | 25            | Invercargill | New Zealand | Auckland    | New Zealand |
      |   5    |    1250     | domestic standard  | 25            | Auckland     | New Zealand | Napier      | New Zealand |

      |   15    |    2310     | domestic air       | 225            | Auckland     | New Zealand | Wellington  | New Zealand |
      |   15    |    2310     | domestic air       | 225            | Wellington   | New Zealand | Auckland    | New Zealand |
      |   15    |    2310     | domestic air       | 225            | Dunedin      | New Zealand | Wellington  | New Zealand |
      |   15    |    2310     | domestic air       | 225            | Wellington   | New Zealand | Dunedin     | New Zealand |

      |   15    |    2310     | domestic standard  | 75            | Auckland     | New Zealand | Wellington  | New Zealand |
      |   15    |    2310     | domestic standard  | 75            | Wellington   | New Zealand | Auckland    | New Zealand |
      |   15    |    2310     | domestic standard  | 75            | Nelson       | New Zealand | Wellington  | New Zealand |
      |   15    |    2310     | domestic standard  | 75            | Invercargill | New Zealand | Auckland    | New Zealand |
      |   15    |    2310     | domestic standard  | 75            | Auckland     | New Zealand | Napier      | New Zealand |


  #  To quote the specification:
  #  'Domestic air priority and domestic standard priority are the same.'
  #
  #  To me this is really ambiguous?
  #    Same in terms of charging the customer?
  #    This is what I will presume it means.
  #
  #   The problem with this is if this is the case, then the above scenario cannot be correct. They contradict.
  #
  Scenario Outline: Domestic air and domestic standard are the same, in terms of price charged to the customer, route calculation is direct
    # We don't have any examples given to us in the data.xml for this. I copied a few from the logs.xml file to the data.xml and made a couple more
    # to make the test a bit more substantive. Not sure if this is allowed or not but otherwise there's no way of testing this specification with
    # the data we were supplied with
    Given an initial customer map
    Given a customer parcel that weighs <Weight>kg
    Given a customer parcel that measures <Measurement>cc
    And I send the customer parcel from "<FromCity>" "<FromCountry>"
    And I send the customer parcel to "<ToCity>" "<ToCountry>"
    Given the parcel is sent only within New Zealand
    Given domestic air and domestic standard routes both exist
    Then sending by domestic air and domestic standard costs the same price for the customer
    Examples:
      | Weight | Measurement | FromCity   | FromCountry | ToCity            | ToCountry   |
      |   5    |  1500       | Dunedin   | New Zealand  | Wellington        | New Zealand |
      |   5    |  1500       | Auckland  | New Zealand  | Wellington        | New Zealand |


  Scenario Outline: Domestic air and domestic standard are the same, in terms of price charged to the customer, route calculation has hops in between
    # I added prices for Dunedin -> Wellington -> Auckland. This fails. I also added Auckland -> Wellington -> Dunedin and it didn't
    # like it either. Clearly the domain doesn't like determining pricing in concatenating hops
    # i.e it will only calculate direct trips (Dunedin -> Auckland) for the customer...
    # This is more of an interesting functional domain note than specification checking... This probably won't ever work unless the
    # 'enhanced kps' systems allow this functional ability.
    Given an initial customer map
    Given a customer parcel that weighs <Weight>kg
    Given a customer parcel that measures <Measurement>cc
    And I send the customer parcel from "<FromCity>" "<FromCountry>"
    And I send the customer parcel to "<ToCity>" "<ToCountry>"
    Given the parcel is sent only within New Zealand
    Given domestic air and domestic standard routes both exist
    Then sending by domestic air and domestic standard costs the same price for the customer
    Examples:
      | Weight | Measurement | FromCity   | FromCountry | ToCity            | ToCountry   |
      |   5    |  1500       |  Dunedin   | New Zealand | Auckland          | New Zealand |
      |   5    |  1500       |  Auckland  | New Zealand | Dunedin           | New Zealand |


  #  To quote the specification:
  #  'Customers can specify a priority for their mail. The higher the priority, the more expensive it is for the customer'
  #
  #  This seems to contradict the above tests that I deciphered to mean that for domestic standard and domestic air, the price for the customer
  #  will be the same. However this is now saying that if we change the priority type then the price should be different
  #  (given same volume, weight, origin and destination).
  #
  #  The specification doesn't specifically state which is higher, I'm going to work on the assumption that
  #  air > standard in terms of priority (as it is usually), but nowhere does it specify this.
  Scenario Outline: The price for the customer wanting to ship by air is greater than standard
    Given an initial customer map
    Given a customer parcel that weighs <Weight>kg
    Given a customer parcel that measures <Measurement>cc
    And I send the customer parcel from "<FromCity>" "<FromCountry>"
    And I send the customer parcel to "<ToCity>" "<ToCountry>"
    Given a direct customer cost route exists for both priority types
    Then I send the priority parcel by "<Type>" air and "<Type>" standard"
    Then sending by air should cost more for the customer than standard
    Examples:
      | Weight | Measurement | FromCity   | FromCountry | ToCity            | ToCountry   | Type      |
      |   5    |  1500       |  Dunedin   | New Zealand | Wellington        | New Zealand | domestic  |
      |   5    |  1500       |  Auckland  | New Zealand | Wellington        | New Zealand | domestic  |