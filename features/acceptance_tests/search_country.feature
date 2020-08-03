Feature: GroupKT /search/text validation
  As a way to verify the integrity of GroupKT /search/text API,
  As a client,
  I want to search for specifics countries, given a text,
  Verify the response payload,
  Verify the different HTTP statuses,
  Verify the response headers,

  Scenario: Check GroupKT /search/text endpoint
    When a client make a GET request to searchtext endpoint with given text
    Then GroupKT responds with a message informing the search was matched for the given text
    And GroupKT responds with a message saying there were no matches for invalid input
    And for the given search queries, GroupKT response has the correct payload
    | text | records_found | name | alpha2code | alpha3code |
    | AU | 9 | Australia;Austria;Guinea-Bissau;Mauritania;Mauritius;Nauru;Palau;Saudi Arabia;Tokelau       |AU,AT,GW,MR,MU,NR,PW,SA,TK  |AUS,AUT,GNB,MRT,MUS,NRU,PLW,SAU,TKL  |
    | AUT | 1 | Austria | AT  | AUT |
    | BRA | 2 | Brazil;Gibraltar | BR,GI  | BRA,GIB |
    | CAN | 4 | American Samoa;Canada;Central African Republic;Dominican Republic | AS,CA,CF,DO  | ASM,CAN,CAF,DOM |
    | hi | 6 | Chile;China;Czechia;Ethiopia;Philippines;Taiwan, Province of China [a] | CL,CN,CZ,ET,PH,TW | CHL,CHN,CZE,ETH,PHL,TWN |
    | thalmic | 0 | | | |
    | feel free to add your tests here | 0 |  |  |  |
    | ; | 0 |  |  |  |

    And the response headers must match the expected
    And each country must have a name, alpha2_code and alpha3_code keys
    And validates if all messages, name, alpha_2code and alpha3_code are encoded correctly

  Scenario: Check GroupKT /search/text endpoint with POST
    When a client make a POST request to searchtext endpoint
    Then GroupKT responds with a 200

  Scenario: Check GroupKT /search/text endpoint with PUT
    When a client make a PUT request to searchtext endpoint
    Then GroupKT responds with a 200

  Scenario: Check GroupKT /search/text endpoint with PATCH
    When a client make a PATCH request to searchtext endpoint
    Then GroupKT responds with a 200

  Scenario: Check GroupKT /search/text endpoint Bad Request
    When a client make a request that results in Bad Request
    Then GroupKT responds with a 400 - Bad Request

  Scenario: Check GroupKT /search/text endpoint Not Found
    When a client make a request to a resource not found
    Then GroupKT responds with a 404 - Not Found