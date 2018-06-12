Feature: Mail Priority Tests

  Scenario Outline: All Should Pass: International air priority from Auckland to Singapore City actually transfers the mail by air
    #
    #  To quote the specification:
    #  'International air priority requires the mail to be transferred by air.'
    #
    #  Let's see if we can get the system to accept mail that has a priority of international air to be transferred
    #  by sea or land. I.E that is, the route returned for that mail is not by air.
    #
    #  If we can, it isn't conforming to specifications (and more than likely the domain model is broken)
    #
    #
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

  Scenario Outline: All Should Pass: International air priority from Wellington to Singapore City actually transfers the mail by air
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

  Scenario Outline: All Should Pass: International air priority from Auckland to Place, Martin Island actually transfers the mail by air
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



  Scenario Outline: All Should Pass: International standard priority from Auckland to Singapore City transfers the mail by land/sea
    #  To quote the specification:
    #  'International standard priority requires that the mail be transferred by land or sea (unless air transfer is the only option).'
    #
    #  Let's see if we can get the system to return a route of air that has a priority of international standard when both land/sea and air are available.
    #  If we can, it isn't conforming to specifications (as land/sea) should've been returned.
    #
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
      | Weight | Measurement | FromCity | FromCountry | ToCity          | ToCountry | MailPriority          |
      | 5      | 500         | Auckland | New Zealand | Singapore City  | Singapore | international standard |
      | 5      | 500         | Auckland | New Zealand | Singapore City  | Singapore | international standard |
      | 5      | 500         | Auckland | New Zealand | Singapore City  | Singapore | international standard |
      | 5      | 500         | Auckland | New Zealand | Singapore City  | Singapore | international standard |
      | 5      | 500         | Auckland | New Zealand | Singapore City  | Singapore | international standard |

  Scenario Outline: All Should Pass: International standard priority from Wellington to Singapore City actually transfers the mail by land/sea
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
      | Weight | Measurement | FromCity   | FromCountry | ToCity          | ToCountry | MailPriority            |
      | 5      | 500         | Wellington | New Zealand | Singapore City  | Singapore | international standard  |
      | 5      | 500         | Wellington | New Zealand | Singapore City  | Singapore | international standard  |
      | 5      | 500         | Wellington | New Zealand | Singapore City  | Singapore | international standard  |
      | 5      | 500         | Wellington | New Zealand | Singapore City  | Singapore | international standard  |
      | 5      | 500         | Wellington | New Zealand | Singapore City  | Singapore | international standard  |

  Scenario Outline: All Should Pass: International standard priority from Auckland to Place, Martin Island actually transfers the mail by land/sea
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


  Scenario Outline: Test international air priority where route has to be by air leaving NZ. Hops inside NZ are mixed priority
    #
    #  To quote the specification:
    #    'KPS does not accept international air priority mail for destinations if there is no transport route to that
    #     destination solely consisting of air freight once that mail has left New Zealand'
    #
    #  What this specification doesn't specify is if, within New Zealand, our routes have to be by Air too, or if they can
    #  be by land/sea and air, before having to be by air when the route goes overseas.
    #
    #  I assume that because it's not specified by the specification, the implementation is correct. This is how the implementation
    #  reacts to this situation:
    #
    #  E.G Nelson -> Montreal fails (mixed types), where:
    #    Nelson      -> Dunedin (Land)
    #    Dunedin     -> Wellington (Air)
    #    Wellington  -> Auckland (Air)
    #    Auckland    -> Montreal (Air)
    #
    #  But Napier -> Montreal passes (only air):
    #    Napier -> Auckland (Air)
    #    Auckland -> Montreal (Air)
    #
    #  Hence it has to have a valid path by Air and air only within New Zealand to pass.
    #
    #  I'm going to write two scenarios outlines, one for the first example using mixed routes types (air/land/sea) within NZ before exiting overseas and
    #  one for the second example where all internal route types are only Air. The first scenario shouldn't pass as the current implementation doesn't support it.
    #
    #  I'm doing this because our tests will be run on enhanced versions of the code:
    #       If the enhanced versions allowed mixed routes within NZ for international air before exiting then both scenarios should pass.
    #       Otherwise, only the 'air only' variant should pass
    #
    Given an initial priority map
    Given a priority parcel that weighs <Weight>kg
    Given a priority parcel that measures <Measurement>cc
    And I send the priority parcel from "<FromCity>" "<FromCountry>"
    Given the parcel is being sent from "New Zealand"
    And I send the priority parcel to "<ToCity>" "<ToCountry>"
    And I send the priority parcel by "international air"
    Then all my routes domestically can be done by air, sea or land
    Then all my routes overseas must be done by "air"
    Examples:
      | Weight | Measurement | FromCity           | FromCountry | ToCity    | ToCountry |
      | 10     | 500         | Palmerston North   | New Zealand | Montreal  | Canada    |
      | 10     | 500         | Nelson             | New Zealand | Montreal  | Canada    |
      | 10     | 500         | Palmerston North   | New Zealand | Place     | Martin Island |
      | 10     | 500         | Nelson             | New Zealand | Place     | Martin Island |

  Scenario Outline: Test international air priority where route has to be by air leaving NZ. Hops inside NZ are solely by air
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


  Scenario Outline: Test if domain model allows mail for domestic air priority to be accepted given no air route
    #   To quote the specification:
    #       'KPS does not accept domestic air priority mail for destinations if there is no transport route
    #        solely consisting of air freight.'
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