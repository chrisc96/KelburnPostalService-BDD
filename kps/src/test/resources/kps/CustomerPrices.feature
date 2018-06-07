Feature: Customer Prices

  To quote the specification:
    'The price customers are charged is based on priority, volume, weight, and destination.'
    'New Zealand domestic destinations are considered the same for the purposes of charging the customer.'

  This indicates that the price the customer pays is irrelevant of where its sent from OR to (within New Zealand),
  given the same weight, volume and priority. That is, we can send from anywhere in New Zealand to anywhere, and the
  price the customer pays for a standardised weight, volume, priority shipment should be the same:

    Scenario Outline: Test customer charged same price for shipping irrelevant of origin and destination in New Zealand (domestic)
      Examples:
        |  |