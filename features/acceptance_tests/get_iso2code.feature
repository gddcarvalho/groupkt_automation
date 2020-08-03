Feature: GroupKT /get/iso2code validation
  As a way to verify the integrity of GroupKT /get/iso2code API,
  As a client,
  I want to search for specifics countries, given a iso2code,
  Verify the response payload,
  Verify the different http statuses,
  Verify the response headers,

  Scenario: Check GroupKT /get/iso2code  endpoint
    When a client make a GET request to getiso2code endpoint with an existing iso2code
    Then GroupKT responds with a message informing the search was matched
    And GroupKT responds with a message saying there were no matches for invalid input of iso2code
    And the response headers must match the expected
    And the returned country must have a name, alpha2_code and alpha3_code keys
    And GroupKT responds with the correct payload for each alpha2code
    And validates if all messages, name, alpha_2code and alpha3_code are encoded correctly on iso2code and iso3code apis

  Scenario: Check GroupKT /get/iso2code endpoint with POST
    When a client make a POST request to getiso2code endpoint
    Then GroupKT responds with a 200

  Scenario: Check GroupKT /get/iso2code endpoint with PUT
    When a client make a PUT request to getiso2code endpoint
    Then GroupKT responds with a 405 - Method Not Allowed

  Scenario: Check GroupKT /get/iso2code endpoint with PATCH
    When a client make a PATCH request to getiso2code endpoint
    Then GroupKT responds with a 405 - Method Not Allowed

  Scenario: Check GroupKT /get/iso2code endpoint Bad Request
    When a client make a request that results in Bad Request
    Then GroupKT responds with a 400 - Bad Request

  Scenario: Check GroupKT /get/iso2code endpoint Not Found
    When a client make a request to a resource not found
    Then GroupKT responds with a 404 - Not Found