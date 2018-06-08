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
  #     To me this is really ambiguous? What does this mean?
  #      o	Same in terms of charging the customer?
  #      o	Same in terms of domestic standard can be shipped by air?
  #      o	Same in terms of domestic air can be shipped by land?
  #
  #  Not sure, lets create scenarios for all of them:
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
      |   5    |  1500       |  Auckland  | New Zealand | Dunedin          | New Zealand |


  Scenario: Domestic land can be shipped by air




  #  To quote the specification:
  #  'Customers can specify a priority for their mail. The higher the priority, the more expensive it is for the customer'
  #
  #  This means that given a non changing set of values for volume, weight, origin and destination, if we change the
  #  priority, the price should change.
  #
  #  If we choose a priority that is 'higher', the change should be higher than the original lower priority cost.
  #  Clearly the converse should hold too.

  # Scenario:




    # KPS does not accept international air priority mail for destinations if there is no transport route to that
  # destination solely consisting of air freight once that mail has left New Zealand.

  # KPS does not accept domestic air priority mail for destinations if there is no transport route solely consisting of air freight.