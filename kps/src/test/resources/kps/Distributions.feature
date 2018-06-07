Feature: Distribution Centres

  The specification states:
    'Mail originating in New Zealand can be sent from one distribution centre to another'
    The distribution centres are 'Auckland, Hamilton, Rotorua, Palmerston North, Wellington, Christchurch, and Dunedin.'

  Hence, we need to test if this is the case, that every distribution centre, somehow, has a route that will go to at least one other
  distribution centre in NZ to satisfy this specification.

  This is dependent on the data.xml file (and potentially if new routes are opened) then the program too.

  Scenario Outline: Testing that the Auckland distribution centre can send to at least one other distribution centre in NZ
    Given an initial map
    Given a parcel that weighs <Weight>kg
    Given a parcel that measures <Measurement> cc
    And I send the parcel from "<FromCity>" "<FromCountry>"
    And I send the parcel to "<ToCity>" "<ToCountry>"
    And I send the parcel by "<MailPriority>"
    And "<FromCity>" "<FromCountry>" distribution centre exists
    And "<ToCity>" "<ToCountry>" distribution centre exists
    Then does a route exist for this route
    Examples:
      | Weight  | Measurement    | FromCity       | FromCountry   | ToCity          | ToCountry   | MailPriority      |
      | 3       | 1500           | Auckland       | New Zealand   | Hamilton        | New Zealand | domestic standard |
      | 3       | 1500           | Auckland       | New Zealand   | Rotorua         | New Zealand | domestic standard |
      | 3       | 1500           | Auckland       | New Zealand   | Palmerston North| New Zealand | domestic standard |
      | 3       | 1500           | Auckland       | New Zealand   | Wellington      | New Zealand | domestic standard |
      | 3       | 1500           | Auckland       | New Zealand   | Christchurch    | New Zealand | domestic standard |
      | 3       | 1500           | Auckland       | New Zealand   | Dunedin         | New Zealand | domestic standard |


  Scenario Outline: Testing that the Hamilton distribution centre can send to at least one other distribution centre in NZ
    Given an initial map
    Given a parcel that weighs <Weight>kg
    Given a parcel that measures <Measurement> cc
    And I send the parcel from "<FromCity>" "<FromCountry>"
    And I send the parcel to "<ToCity>" "<ToCountry>"
    And I send the parcel by "<MailPriority>"
    Then does a route exist for this route
    Examples:
      | Weight  | Measurement    | FromCity       | FromCountry   | ToCity          | ToCountry   | MailPriority      |
      | 3       | 1500           | Hamilton       | New Zealand   | Auckland        | New Zealand | domestic standard |
      | 3       | 1500           | Hamilton       | New Zealand   | Palmerston North| New Zealand | domestic standard |
      | 3       | 1500           | Hamilton       | New Zealand   | Wellington      | New Zealand | domestic standard |
      | 3       | 1500           | Hamilton       | New Zealand   | Christchurch    | New Zealand | domestic standard |
      | 3       | 1500           | Hamilton       | New Zealand   | Dunedin         | New Zealand | domestic standard |
      | 3       | 1500           | Hamilton       | New Zealand   | Rotorua         | New Zealand | domestic standard |

  Scenario Outline: Testing that the Palmerston North distribution centre can send to at least one other distribution centre in NZ
    Given an initial map
    Given a parcel that weighs <Weight>kg
    Given a parcel that measures <Measurement> cc
    And I send the parcel from "<FromCity>" "<FromCountry>"
    And I send the parcel to "<ToCity>" "<ToCountry>"
    And I send the parcel by "<MailPriority>"
    Then does a route exist for this route
    Examples:
      | Weight  | Measurement    | FromCity       | FromCountry   | ToCity          | ToCountry   | MailPriority      |
      | 3       | 1500           | Palmerston North | New Zealand   | Hamilton        | New Zealand | domestic standard |
      | 3       | 1500           | Palmerston North | New Zealand   | Auckland        | New Zealand | domestic standard |
      | 3       | 1500           | Palmerston North | New Zealand   | Wellington      | New Zealand | domestic standard |
      | 3       | 1500           | Palmerston North | New Zealand   | Christchurch    | New Zealand | domestic standard |
      | 3       | 1500           | Palmerston North | New Zealand   | Dunedin         | New Zealand | domestic standard |
      | 3       | 1500           | Palmerston North | New Zealand   | Rotorua         | New Zealand | domestic standard |

  Scenario Outline: Testing that the Wellington distribution centre can send to at least one other distribution centre in NZ
    Given an initial map
    Given a parcel that weighs <Weight>kg
    Given a parcel that measures <Measurement> cc
    And I send the parcel from "<FromCity>" "<FromCountry>"
    And I send the parcel to "<ToCity>" "<ToCountry>"
    And I send the parcel by "<MailPriority>"
    Then does a route exist for this route
    Examples:
      | Weight  | Measurement    | FromCity       | FromCountry   | ToCity          | ToCountry   | MailPriority      |
      | 3       | 1500           | Wellington | New Zealand   | Palmerston North| New Zealand | domestic standard |
      | 3       | 1500           | Wellington | New Zealand   | Auckland        | New Zealand | domestic standard |
      | 3       | 1500           | Wellington | New Zealand   | Hamilton        | New Zealand | domestic standard |
      | 3       | 1500           | Wellington | New Zealand   | Christchurch    | New Zealand | domestic standard |
      | 3       | 1500           | Wellington | New Zealand   | Dunedin         | New Zealand | domestic standard |
      | 3       | 1500           | Wellington | New Zealand   | Rotorua         | New Zealand | domestic standard |


  Scenario Outline: Testing that the Christchurch distribution centre can send to at least one other distribution centre in NZ
    Given an initial map
    Given a parcel that weighs <Weight>kg
    Given a parcel that measures <Measurement> cc
    And I send the parcel from "<FromCity>" "<FromCountry>"
    And I send the parcel to "<ToCity>" "<ToCountry>"
    And I send the parcel by "<MailPriority>"
    Then does a route exist for this route
    Examples:
      | Weight  | Measurement    | FromCity       | FromCountry   | ToCity          | ToCountry   | MailPriority      |
      | 3       | 1500           | Christchurch | New Zealand   | Palmerston North| New Zealand | domestic standard |
      | 3       | 1500           | Christchurch | New Zealand   | Auckland        | New Zealand | domestic standard |
      | 3       | 1500           | Christchurch | New Zealand   | Wellington      | New Zealand | domestic standard |
      | 3       | 1500           | Christchurch | New Zealand   | Hamilton        | New Zealand | domestic standard |
      | 3       | 1500           | Christchurch | New Zealand   | Dunedin         | New Zealand | domestic standard |
      | 3       | 1500           | Christchurch | New Zealand   | Rotorua         | New Zealand | domestic standard |

  Scenario Outline: Testing that the Dunedin distribution centre can send to at least one other distribution centre in NZ
    Given an initial map
    Given a parcel that weighs <Weight>kg
    Given a parcel that measures <Measurement> cc
    And I send the parcel from "<FromCity>" "<FromCountry>"
    And I send the parcel to "<ToCity>" "<ToCountry>"
    And I send the parcel by "<MailPriority>"
    Then does a route exist for this route
    Examples:
      | Weight  | Measurement    | FromCity       | FromCountry   | ToCity          | ToCountry   | MailPriority      |
      | 3       | 1500           | Dunedin      | New Zealand   | Palmerston North| New Zealand | domestic standard |
      | 3       | 1500           | Dunedin      | New Zealand   | Auckland        | New Zealand | domestic standard |
      | 3       | 1500           | Dunedin      | New Zealand   | Wellington      | New Zealand | domestic standard |
      | 3       | 1500           | Dunedin      | New Zealand   | Hamilton        | New Zealand | domestic standard |
      | 3       | 1500           | Dunedin      | New Zealand   | Christchurch    | New Zealand | domestic standard |
      | 3       | 1500           | Dunedin      | New Zealand   | Rotorua         | New Zealand | domestic standard |

  Scenario Outline: Testing that the Rotorua distribution centre can send to at least one other distribution centre in NZ
    Given an initial map
    Given a parcel that weighs <Weight>kg
    Given a parcel that measures <Measurement> cc
    And I send the parcel from "<FromCity>" "<FromCountry>"
    And I send the parcel to "<ToCity>" "<ToCountry>"
    And I send the parcel by "<MailPriority>"
    Then does a route exist for this route
    Examples:
      | Weight  | Measurement    | FromCity       | FromCountry   | ToCity          | ToCountry   | MailPriority      |
      | 3       | 1500           | Rotorua      | New Zealand   | Palmerston North| New Zealand | domestic standard |
      | 3       | 1500           | Rotorua      | New Zealand   | Auckland        | New Zealand | domestic standard |
      | 3       | 1500           | Rotorua      | New Zealand   | Wellington      | New Zealand | domestic standard |
      | 3       | 1500           | Rotorua      | New Zealand   | Hamilton        | New Zealand | domestic standard |
      | 3       | 1500           | Rotorua      | New Zealand   | Christchurch    | New Zealand | domestic standard |
      | 3       | 1500           | Rotorua      | New Zealand   | Dunedin         | New Zealand | domestic standard |


  Scenario Outline: Testing that sending to our own distribution centre shouldn't be possible

    If the distribution centre supplied doesn't exist, it will not pass.

    Given an initial map
    Given a parcel that weighs 5kg
    Given a parcel that measures 2000 cc
    Given "<FromCity>" "<FromCountry>" distribution centre exists
    And I send the parcel from "<FromCity>" "<FromCountry>"
    And I send the parcel to "<ToCity>" "<ToCountry>"
    And I send the parcel by "<MailPriority>"
    Then does a route not exist for this route
    Examples:
      | FromCity          | FromCountry   | ToCity            | ToCountry   | MailPriority      |
      | Auckland          | New Zealand   | Auckland          | New Zealand | domestic standard |
      | Hamilton          | New Zealand   | Hamilton          | New Zealand | domestic standard |
      | Rotorua           | New Zealand   | Rotorua           | New Zealand | domestic standard |
      | Wellington        | New Zealand   | Wellington        | New Zealand | domestic standard |
      | Christchurch      | New Zealand   | Christchurch      | New Zealand | domestic standard |
      | Dunedin           | New Zealand   | Dunedin           | New Zealand | domestic standard |
      | Palmerston North  | New Zealand   | Palmerston North  | New Zealand | domestic standard |
