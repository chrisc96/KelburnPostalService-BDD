Feature: Mail Priority Tests

  To quote the specification:
  'International air priority requires the mail to be transferred by air.'

  Let's see if we can get the system to accept mail that has a priority of international air to be transferred
  by sea or land. If we can, it isn't conforming to specifications (and more than likely the domain model is broken)

  Let's run the same values multiple times so we can double check for consistency reproduction issues.

  Scenario:




  To quote the specification:
  'International standard priority requires that the mail be transferred by land or sea (unless air transfer is the only option).'

  Let's see if we can get the system to return a route of air that has a priority of international standard when both land/sea and air are available.
  If we can, it isn't conforming to specifications (as land/sea) should've been returned.

  Let's run the same values multiple times so we can double check for consistency reproduction issues.

  Scenario:



  To quote the specification:
    'Domestic air priority and domestic standard priority are the same.'

  •	What does this mean?
      o	Same in terms of charging the customer? Equal priority?
      o	Same in terms of domestic standard can be shipped by air?
      o	Same in terms of domestic air can be shipped by land?

  Not sure, lets create scenarios for all of them:

  Scenario:

  Scenario:

  Scenario:




  To quote the specification:
  'Customers can specify a priority for their mail. The higher the priority, the more expensive it is for the customer'

  This means that given a non changing set of values for volume, weight, origin and destination, if we change the
  priority, the price should change.

  If we choose a priority that is 'higher', the change should be higher than the original lower priority cost.
  Clearly the converse should hold too.

  Scenario: