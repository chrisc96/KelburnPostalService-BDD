Feature: Test Mail Delivery Costs for KPS

  Scenario Outline: Price for mail originating from overseas (outside NZ) should be free for KPS.
    #
    #    To reference the specification it states that:
    #        'mail originating from overseas for New Zealand destinations is delivered at no cost'
    #
    #    Contradiction:
    #        'All mail that goes through KPS originates in New Zealand'
    #
    #    Not really sure about this... I am assuming that if we add mail to the KPS system from overseas to NZ then the expected
    #    cost should be 0, even though it says all mail should originate in NZ.
    #
    #    To clarify, I'm also presuming 'no cost' is referring to zero cost for KPS not the customer.
    #
    #    Therefore if we setup tests for mail with a from city/country from outside of new zealand, the expected cost should
    #    be 0.
    #
    #    We will only use routes given to us using the default data.xml
    #
    #    The routes used in this test can have hops in between reaching their destinations. It's irrelevant for calculating costs.
    #
    Given an initial map
    Given a parcel that weighs <Weight>kg
    Given a parcel that measures <Measurement> cc
    And I send the parcel from "<FromCity>" "<FromCountry>"
    And I send the parcel to "<ToCity>" "<ToCountry>"
    And I send the parcel by "<MailPriority>"
    Then does a route exist for this route
    Then the cost is $<ExpectedCost>
    Examples:
      | Weight  | Measurement    | FromCity        | FromCountry   | ToCity          | ToCountry   | MailPriority           | ExpectedCost |
      | 5       | 1000           | Singapore City  | Singapore     | Wellington      | New Zealand | international standard | 0            |
      | 5       | 1000           | Singapore City  | Singapore     | Auckland        | New Zealand | international standard | 0            |
      | 5       | 1000           | Singapore City  | Singapore     | Wellington      | New Zealand | international standard | 0            |
      | 5       | 1000           | Place           | Martin Island | Auckland        | New Zealand | international standard | 0            |
      | 5       | 1000           | Singapore City  | Singapore     | Auckland        | New Zealand | international air      | 0            |
      | 5       | 1000           | Singapore City  | Singapore     | Wellington      | New Zealand | international air      | 0            |
      | 5       | 1000           | Montreal        | Canada        | Auckland        | New Zealand | international air      | 0            |
      | 5       | 1000           | Sydney          | Australia     | Auckland        | New Zealand | international air      | 0            |


  Scenario Outline: Test all mail to an overseas country goes to the same port
    #
    #    To quote the specification:
    #      'For the sake of simplicity, it is assumed that all mail to a country goes to the same port.'
    #      AND
    #      'internationally to an overseas sea/air port where it is then handled by a local mail service partner.'
    #
    #    This means that given some country outside of NZ, we shouldn't ever have more than one City for a given overseas
    #    country as this would mean that all mail is not going through to the same port.
    #
    #    This makes us reliant on the data.xml, but it still tests the specification, as the data.xml is used by the domain program.
    #    I added all the overseas countries found in the info file.
    #
    Given an initial map
    And I want to send a parcel to the overseas country: "<Country>"
    Then I should be only able to send it to one place
    Examples:
      | Country   |
      | Australia |
      | Singapore |
      | Martin Island  |
      | Canada         |

  #
  #
  # GENERAL MAIL SENDING TESTS
  #
  #

  Scenario: Sending air (nothing) through mail

    Not specified in specification or in program but a side thought...
    I'm assuming the domain models' output is correct that we can in-fact 'send air' and a cost of $0 is fine
    as we're not actually sending anything.

    Mainly used just to see if the 'enhanced KPS systems' will do something differently that disallow this.

    Given an initial map
    Given a parcel that weighs 0kg
    Given a parcel that measures 0 cc
    And I send the parcel from "Wellington" "New Zedwdaland"
    And I send the parcel to "Palmerston North" "New Zealand"
    And I send the parcel by "domestic standard"
    Then the cost is $0


  Scenario: Example Send Mail
    Given an initial map
    Given a parcel that weighs 1kg
    Given a parcel that measures 1000 cc
    And I send the parcel from "Wellington" "New Zealand"
    And I send the parcel to "Palmerston North" "New Zealand"
    And I send the parcel by "domestic standard"
    Then the cost is $5


  Scenario Outline: Send really heavy mail (that shouldn't be accepted)
    Given an initial map
    Given a parcel that weighs <Weight>kg
    Given a parcel that measures <Measurement> cc
    And I send the parcel from "Wellington" "New Zealand"
    And I send the parcel to "Palmerston North" "New Zealand"
    And I send the parcel by "domestic standard"
    Then a route shouldn't exist for this mail
    Examples:
      | Weight | Measurement |
      | 500    | 40000       |
      | 40     | 250000      |
      | 500    | 600000      |

  Scenario Outline: Send mail (domestic & overseas) with direct transport routes (No hops)
    #
    # Tests for sending mail (both domestically and internationally).
    #
    # None of these routes should have possible hops in between. This makes it easier to validate the routes returned as correct.
    #
    # We're assuming that all mail originates in New Zealand as per the specification.
    # See scenario outline titled 'Price for mail originating from overseas (outside NZ) should be free for KPS' in Mail.feature for
    # mail not originating in NZ test.
    #
    # Problem: I noticed that for example:
    #   Gisborne -> Napier has two companies that send by domestic standard. One has a weight/volume cost of 2. Other's is 3.
    #   If we're testing the expected costs, and we know that the domain model isn't producing consistent results
    #   (i.e lowest cost route returned or something like that) then should we be testing all possible expected costs?
    #       I decided to.
    #
    # The number of values in the column 'expected cost' signifies how many different companies ship this route and their possible costs.
    #
    Given an initial map
    Given a parcel that weighs <Weight>kg
    Given a parcel that measures <Measurement> cc
    And I send the parcel from "<FromCity>" "<FromCountry>"
    And I send the parcel to "<ToCity>" "<ToCountry>"
    And I send the parcel by "<MailPriority>"
    Given the mail is being sent from "New Zealand"
    Given a direct route (no hops) exists for this mail
    Then the mailing route returned is of type "<MailPriority>"
    Then the expected cost should be one of $"<ExpectedCost>"
    Examples:
      | Weight  | Measurement | FromCity          | FromCountry     | ToCity            | ToCountry      | MailPriority            | ExpectedCost     |
      | 182     | 85000       | Invercargill      |  New Zealand    | Dunedin           | New Zealand    | domestic standard       | 728              |
      | 52      | 180000      | Dunedin           |  New Zealand    | Invercargill      | New Zealand    | domestic standard       | 720              |
      | 37      | 21000       | Dunedin           |  New Zealand    | Nelson            | New Zealand    | domestic standard       | 222              |
      | 43      | 108000      | Nelson            |  New Zealand    | Dunedin           | New Zealand    | domestic standard       | 864              |
      | 34      | 184000      | Wellington        |  New Zealand    | Palmerston North  | New Zealand    | domestic standard       | 920              |
      | 71      | 2000        | Palmerston North  |  New Zealand    | Wellington        | New Zealand    | domestic standard       | 355              |
      | 15      | 24000       | Palmerston North  |  New Zealand    | New Plymouth      | New Zealand    | domestic standard       | 168              |
      | 183     | 99000       | New Plymouth      |  New Zealand    | Palmerston North  | New Zealand    | domestic standard       | 1281             |
      | 104     | 98000       | Palmerston North  |  New Zealand    | Gisborne          | New Zealand    | domestic standard       | 624              |
      | 92      | 148000      | Gisborne          |  New Zealand    | Palmerston North  | New Zealand    | domestic standard       | 888              |
      | 104     | 180000      | Palmerston North  |  New Zealand    | Napier            | New Zealand    | domestic standard       | 1260             |
      | 37      | 21000       | Napier            |  New Zealand    | Palmerston North  | New Zealand    | domestic standard       | 259              |
      | 43      | 108000      | Gisborne          |  New Zealand    | Napier            | New Zealand    | domestic standard       | 216, 324         |
      | 34      | 184000      | Napier            |  New Zealand    | Gisborne          | New Zealand    | domestic standard       | 368, 552         |
      | 15      | 24000       | Napier            |  New Zealand    | Gisborne          | New Zealand    | domestic standard       | 48, 72           |
      | 183     | 99000       | Auckland          |  New Zealand    | Gisborne          | New Zealand    | domestic standard       | 732              |
      | 104     | 98000       | Gisborne          |  New Zealand    | Auckland          | New Zealand    | domestic standard       | 416, 104         |
      | 104     | 180000      | Auckland          |  New Zealand    | Gisborne          | New Zealand    | domestic standard       | 720              |
      | 37      | 21000       | Gisborne          |  New Zealand    | Auckland          | New Zealand    | domestic standard       | 148, 37          |
      | 43      | 108000      | Auckland          |  New Zealand    | New Plymouth      | New Zealand    | domestic standard       | 108              |
      | 34      | 184000      | Auckland          |  New Zealand    | Whangarei         | New Zealand    | domestic standard       | 368              |
      | 71      | 2000        | Nelson            |  New Zealand    | Wellington        | New Zealand    | domestic standard       | 426              |
      | 15      | 24000       | Wellington        |  New Zealand    | Nelson            | New Zealand    | domestic standard       | 144              |
      | 104     | 180000      | Auckland          |  New Zealand    | Singapore City    | Singapore      | international standard  | 3600             |
      | 37      | 21000       | Auckland          |  New Zealand    | Place             | Martin Island  | international standard  | 555              |
      | 34      | 184000      | Dunedin           |  New Zealand    | Invercargill      | New Zealand    | domestic air            | 2760             |
      | 71      | 2000        | Invercargill      |  New Zealand    | Dunedin           | New Zealand    | domestic air            | 1065             |
      | 15      | 24000       | Dunedin           |  New Zealand    | Wellington        | New Zealand    | domestic air            | 480              |
      | 183     | 99000       | Wellington        |  New Zealand    | Dunedin           | New Zealand    | domestic air            | 3660             |
      | 104     | 98000       | Auckland          |  New Zealand    | Wellington        | New Zealand    | domestic air            | 2080, 1976       |
      | 92      | 148000      | Wellington        |  New Zealand    | Auckland          | New Zealand    | domestic air            | 2812, 2960       |
      | 104     | 180000      | Auckland          |  New Zealand    | Wellington        | New Zealand    | domestic air            | 3600, 3420       |
      | 37      | 21000       | Wellington        |  New Zealand    | Auckland          | New Zealand    | domestic air            | 703, 740         |
      | 43      | 108000      | Napier            |  New Zealand    | Wellington        | New Zealand    | domestic air            | 1296             |
      | 34      | 184000      | Wellington        |  New Zealand    | Napier            | New Zealand    | domestic air            | 2208             |
      | 71      | 2000        | Napier            |  New Zealand    | Auckland          | New Zealand    | domestic air            | 994              |
      | 15      | 24000       | Auckland          |  New Zealand    | Napier            | New Zealand    | domestic air            | 336              |
      | 104     | 98000       | Auckland          |  New Zealand    | Sydney            | Australia      | international air       | 2704, 2808       |
      | 92      | 148000      | Auckland          |  New Zealand    | Place             | Martin Island  | international air       | 5180             |
      | 37      | 21000       | Auckland          |  New Zealand    | Sydney            | Australia      | international air       | 962, 999         |
      | 34      | 184000      | Auckland          |  New Zealand    | Montreal          | Canada         | international air       | 4600             |
      | 15      | 24000       | Auckland          |  New Zealand    | Singapore City    | Singapore      | international air       | 552              |