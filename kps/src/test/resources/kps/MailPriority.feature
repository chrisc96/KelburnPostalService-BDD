Feature: Mail Priority Tests

  #  To quote the specification:
  #  'International air priority requires the mail to be transferred by air.'
  #
  #  Let's see if we can get the system to accept mail that has a priority of international air to be transferred
  #  by sea or land. I.E that is, the route returned for that mail is not by air.
  #
  #  If we can, it isn't conforming to specifications (and more than likely the domain model is broken)
  Scenario Outline: International air priority from Auckland to Singapore City actually transfers the mail by air
    # Testing the same inputs multiple times to make sure the domain model reproduces the same results consistently.
    # All should pass or fail. If not, there's consistency issues.
    Given an initial priority map
    Given a priority parcel that weighs <Weight>kg
    Given a priority parcel that measures <Measurement>cc
    And I send the priority parcel from "<FromCity>" "<FromCountry>"
    And I send the priority parcel to "<ToCity>" "<ToCountry>"
    And I send the priority parcel by "<MailPriority>"
    Given the route exists
    Then the route returned is by air
    Examples:
      | Weight | Measurement | FromCity | FromCountry | ToCity          | ToCountry | MailPriority        |
      | 5      | 500         | Auckland | New Zealand | Singapore City  | Singapore | international air   |
      | 5      | 500         | Auckland | New Zealand | Singapore City  | Singapore | international air   |
      | 5      | 500         | Auckland | New Zealand | Singapore City  | Singapore | international air   |
      | 5      | 500         | Auckland | New Zealand | Singapore City  | Singapore | international air   |
      | 5      | 500         | Auckland | New Zealand | Singapore City  | Singapore | international air   |

  Scenario Outline: International air priority from Wellington to Singapore City actually transfers the mail by air
    # Testing the same inputs multiple times to make sure the domain model reproduces the same results consistently.
    # All should pass or fail. If not, there's consistency issues.    Given an initial priority map
    Given an initial priority map
    Given a priority parcel that weighs <Weight>kg
    Given a priority parcel that measures <Measurement>cc
    And I send the priority parcel from "<FromCity>" "<FromCountry>"
    And I send the priority parcel to "<ToCity>" "<ToCountry>"
    And I send the priority parcel by "<MailPriority>"
    Given the route exists
    Then the route returned is by air
    Examples:
      | Weight | Measurement | FromCity | FromCountry   | ToCity          | ToCountry | MailPriority      |
      | 5      | 500         | Wellington | New Zealand | Singapore City  | Singapore | international air |
      | 5      | 500         | Wellington | New Zealand | Singapore City  | Singapore | international air |
      | 5      | 500         | Wellington | New Zealand | Singapore City  | Singapore | international air |
      | 5      | 500         | Wellington | New Zealand | Singapore City  | Singapore | international air |
      | 5      | 500         | Wellington | New Zealand | Singapore City  | Singapore | international air |

  Scenario Outline: International air priority from Auckland to Place, Martin Island actually transfers the mail by air
    # Testing the same inputs multiple times to make sure the domain model reproduces the same results consistently.
    # All should pass or fail. If not, there's consistency issues.    Given an initial priority map
    Given an initial priority map
    Given a priority parcel that weighs <Weight>kg
    Given a priority parcel that measures <Measurement>cc
    And I send the priority parcel from "<FromCity>" "<FromCountry>"
    And I send the priority parcel to "<ToCity>" "<ToCountry>"
    And I send the priority parcel by "<MailPriority>"
    Given the route exists
    Then the route returned is by air
    Examples:
      | Weight | Measurement | FromCity | FromCountry | ToCity  | ToCountry     | MailPriority      |
      | 5      | 500         | Auckland | New Zealand | Place   | Martin Island | international air |
      | 5      | 500         | Auckland | New Zealand | Place   | Martin Island | international air |
      | 5      | 500         | Auckland | New Zealand | Place   | Martin Island | international air |
      | 5      | 500         | Auckland | New Zealand | Place   | Martin Island | international air |
      | 5      | 500         | Auckland | New Zealand | Place   | Martin Island | international air |


  #  To quote the specification:
  #  'International standard priority requires that the mail be transferred by land or sea (unless air transfer is the only option).'
  #
  #  Let's see if we can get the system to return a route of air that has a priority of international standard when both land/sea and air are available.
  #  If we can, it isn't conforming to specifications (as land/sea) should've been returned.
  #
  Scenario Outline: International standard priority from Auckland to Singapore City actually transfers the mail by land/sea
    # Testing the same inputs multiple times to make sure the domain model reproduces the same results consistently.
    # All should pass or fail. If not, there's consistency issues.
    Given an initial priority map
    Given a priority parcel that weighs <Weight>kg
    Given a priority parcel that measures <Measurement>cc
    And I send the priority parcel from "<FromCity>" "<FromCountry>"
    And I send the priority parcel to "<ToCity>" "<ToCountry>"
    And I send the priority parcel by "<MailPriority>"
    Given the route exists
    Given air is not the only option
    Then the route returned is by land or sea
    Examples:
      | Weight | Measurement | FromCity | FromCountry | ToCity          | ToCountry | MailPriority        |
      | 5      | 500         | Auckland | New Zealand | Singapore City  | Singapore | international standard |
      | 5      | 500         | Auckland | New Zealand | Singapore City  | Singapore | international standard |
      | 5      | 500         | Auckland | New Zealand | Singapore City  | Singapore | international standard |
      | 5      | 500         | Auckland | New Zealand | Singapore City  | Singapore | international standard |
      | 5      | 500         | Auckland | New Zealand | Singapore City  | Singapore | international standard |

  Scenario Outline: International standard priority from Wellington to Singapore City actually transfers the mail by land/sea
    # Testing the same inputs multiple times to make sure the domain model reproduces the same results consistently.
    # All should pass or fail. If not, there's consistency issues.
    Given an initial priority map
    Given a priority parcel that weighs <Weight>kg
    Given a priority parcel that measures <Measurement>cc
    And I send the priority parcel from "<FromCity>" "<FromCountry>"
    And I send the priority parcel to "<ToCity>" "<ToCountry>"
    And I send the priority parcel by "<MailPriority>"
    Given the route exists
    Given air is not the only option
    Then the route returned is by land or sea
    Examples:
      | Weight | Measurement | FromCity | FromCountry | ToCity          | ToCountry | MailPriority        |
      | 5      | 500         | Wellington | New Zealand | Singapore City  | Singapore | international standard |
      | 5      | 500         | Wellington | New Zealand | Singapore City  | Singapore | international standard |
      | 5      | 500         | Wellington | New Zealand | Singapore City  | Singapore | international standard |
      | 5      | 500         | Wellington | New Zealand | Singapore City  | Singapore | international standard |
      | 5      | 500         | Wellington | New Zealand | Singapore City  | Singapore | international standard |

  Scenario Outline: International standard priority from Auckland to Place, Martin Island actually transfers the mail by land/sea
    # Testing the same inputs multiple times to make sure the domain model reproduces the same results consistently.
    # All should pass or fail. If not, there's consistency issues.
    Given an initial priority map
    Given a priority parcel that weighs <Weight>kg
    Given a priority parcel that measures <Measurement>cc
    And I send the priority parcel from "<FromCity>" "<FromCountry>"
    And I send the priority parcel to "<ToCity>" "<ToCountry>"
    And I send the priority parcel by "<MailPriority>"
    Given the route exists
    Given air is not the only option
    Then the route returned is by land or sea
    Examples:
      | Weight | Measurement | FromCity | FromCountry | ToCity| ToCountry     | MailPriority           |
      | 5      | 500         | Auckland | New Zealand | Place | Martin Island | international standard |
      | 5      | 500         | Auckland | New Zealand | Place | Martin Island | international standard |
      | 5      | 500         | Auckland | New Zealand | Place | Martin Island | international standard |
      | 5      | 500         | Auckland | New Zealand | Place | Martin Island | international standard |
      | 5      | 500         | Auckland | New Zealand | Place | Martin Island | international standard |


  #  To quote the specification:
  #    'Domestic air priority and domestic standard priority are the same.'
  #
  #     To me this is really ambiguous?
  #      o	Same in terms of charging the customer?
  #         This is what I will presume it means.
  #
  #
  Scenario Outline: Domestic air and domestic standard are the same price for the customer, route calculation is direct
    # We don't have any examples given to us in the data.xml for this. I copied a few from the logs.xml file to the data.xml and made a couple more
    # to make the test a bit more substantive. Not sure if this is allowed or not but otherwise there's no way of testing this specification with
    # the data we were supplied with
    Given an initial priority map
    Given a priority parcel that weighs <Weight>kg
    Given a priority parcel that measures <Measurement>cc
    And I send the priority parcel from "<FromCity>" "<FromCountry>"
    And I send the priority parcel to "<ToCity>" "<ToCountry>"
    And I send the priority parcel by domestic air and domestic standard"
    Then sending by domestic air and domestic standard costs the same price for the customer
    Examples:
      | Weight | Measurement | FromCity   | FromCountry | ToCity            | ToCountry   |
      |   5    |  1500       |  Dunedin   | New Zealand | Wellington        | New Zealand |
      |   5    |  1500       |  Auckland  | New Zealand | Wellington        | New Zealand |

  Scenario Outline: Domestic air and domestic standard are the same price for the customer, route calculation has hops in between
    # I added prices for Dunedin -> Wellington -> Auckland. This fails. I also added Auckland -> Wellington -> Dunedin and it didn't
    # like it either. Clearly the domain doesn't like determining pricing in concatenating hops
    # i.e it will only calculate direct trips (Dunedin -> Auckland) for the customer...
    # This is more of an interesting functional domain note than specification checking...

    Given an initial priority map
    Given a priority parcel that weighs <Weight>kg
    Given a priority parcel that measures <Measurement>cc
    And I send the priority parcel from "<FromCity>" "<FromCountry>"
    And I send the priority parcel to "<ToCity>" "<ToCountry>"
    And I send the priority parcel by domestic air and domestic standard"
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
  #  (given same volume, weight, origin and destination). This is ridiculous...
  #
  #  The specification doesn't specifically state which is higher, I'm going to work on the assumption that
  #  air > standard in terms of priority (as it is usually), but nowhere does it specify this.
  Scenario Outline: The price for the customer wanting to ship by air is greater than standard
    Given an initial priority map
    Given a priority parcel that weighs <Weight>kg
    Given a priority parcel that measures <Measurement>cc
    And I send the priority parcel from "<FromCity>" "<FromCountry>"
    And I send the priority parcel to "<ToCity>" "<ToCountry>"
    Given a direct customer cost route exists for both priority types
    Then I send the priority parcel by "<Type>" air and "<Type>" standard"
    Then sending by air should cost more for the customer than standard
    Examples:
    | Weight | Measurement | FromCity   | FromCountry | ToCity            | ToCountry   | Type      |
    |   5    |  1500       |  Dunedin   | New Zealand | Wellington        | New Zealand | domestic  |
    |   5    |  1500       |  Auckland  | New Zealand | Wellington        | New Zealand | domestic  |


  # To quote the specification:
  #   'KPS does not accept international air priority mail for destinations if there is no transport route to that
  #    destination solely consisting of air freight once that mail has left New Zealand'
  #
  # What this specification doesn't specify is if, within New Zealand, our routes have to be by Air too, or if they can
  # be by land/sea and air, before having to be by air when the route goes overseas.
  #
  # I assume that because it's not specified by the specification, the implementation is correct. This is how the implementation
  # reacts to this situation:
  #
  # E.G Nelson -> Montreal fails (mixed types), where:
  #   Nelson      -> Dunedin (Land)
  #   Dunedin     -> Wellington (Air)
  #   Wellington  -> Auckland (Air)
  #   Auckland    -> Montreal (Air)
  #
  # But Napier -> Montreal passes (only air):
  #   Napier -> Auckland (Air)
  #   Auckland -> Montreal (Air)
  #
  # Hence it has to have a valid path by Air and air only within New Zealand to pass.
  #
  # I'm going to write two scenarios outlines, one for the first example using mixed routes types (air/land/sea) within NZ before exiting overseas and
  # one for the second example where all internal route types are only Air. The first scenario shouldn't pass as the current implementation doesn't support it.
  #
  # I'm doing this because our tests will be run on enhanced versions of the code:
  #     If the enhanced versions allowed mixed routes within NZ for international air before exiting then both scenarios should pass.
  #     Otherwise, only the 'air only' variant should pass
  #
  Scenario Outline: Test international air priority where route has to be by air leaving NZ. Hops inside NZ are mixed priority
    Given an initial priority map
    Given a priority parcel that weighs <Weight>kg
    Given a priority parcel that measures <Measurement>cc
    And I send the priority parcel from "<FromCity>" "<FromCountry>"
    Given the parcel is being sent from "New Zealand"
    And I send the priority parcel to "<ToCity>" "<ToCountry>"
    And I send the priority parcel by "international air"
    Then all my routes domestically can be done by air, sea or land
    Given all my routes overseas must be done by "air"
    Examples:
      | Weight | Measurement | FromCity           | FromCountry | ToCity    | ToCountry |
      | 10     | 500         | Palmerston North   | New Zealand | Montreal  | Canada    |
      | 10     | 500         | Nelson             | New Zealand | Montreal  | Canada    |
      | 10     | 500         | Palmerston North   | New Zealand | Place     | Martin Island |
      | 10     | 500         | Nelson             | New Zealand | Place     | Martin Island |

  Scenario Outline: Test international air priority where route has to be by air leaving NZ. Hops inside NZ are solely by air too
    Given an initial priority map
    Given a priority parcel that weighs <Weight>kg
    Given a priority parcel that measures <Measurement>cc
    And I send the priority parcel from "<FromCity>" "<FromCountry>"
    Given the parcel is being sent from "New Zealand"
    And I send the priority parcel to "<ToCity>" "<ToCountry>"
    And I send the priority parcel by "international air"
    But all my routes domestically must be done by "air"
    But all my routes overseas must be done by "air"
    Examples:
      | Weight | Measurement | FromCity           | FromCountry | ToCity    | ToCountry     |
      | 10     | 500         | Auckland           | New Zealand | Montreal  | Canada        |
      | 10     | 500         | Napier             | New Zealand | Montreal  | Canada        |
      | 10     | 500         | Wellington         | New Zealand | Montreal  | Canada        |
      | 10     | 500         | Auckland           | New Zealand | Place     | Martin Island |
      | 10     | 500         | Napier             | New Zealand | Place     | Martin Island |
      | 10     | 500         | Wellington         | New Zealand | Place     | Martin Island |


  # To quote the specification:
  #     'KPS does not accept domestic air priority mail for destinations if there is no transport route
  #      solely consisting of air freight.'
  #
  Scenario Outline: Test if domain model allows mail for domestic air priority to be accepted given no air route
    Given an initial priority map
    Given a priority parcel that weighs <Weight>kg
    Given a priority parcel that measures <Measurement>cc
    And I send the priority parcel from "<FromCity>" "<FromCountry>"
    And I send the priority parcel to "<ToCity>" "<ToCountry>"
    And I send the priority parcel by "domestic air"
    Then all my routes domestically must be done by "air"
    Examples:
      | Weight | Measurement | FromCity     | FromCountry | ToCity     | ToCountry      |
      | 2      | 5000        | Nelson       | New Zealand | Wellington | New Zealand    |
      | 2      | 5000        | Dunedin      | New Zealand | Nelson     | New Zealand    |
      | 4      | 2500        | Napier       | New Zealand | Auckland   | New Zealand    |
      | 4      | 2500        | Wellington   | New Zealand | Auckland   | New Zealand    |