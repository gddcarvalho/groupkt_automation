Feature: GroupKT /get/all validation
  As a way to verify the integrity of GroupKT /get/all API,
  As a client,
  I want to get all countries,
  Verify the response payload,
  Verify the different http statuses,
  Verify the response headers,

  Scenario: Check GroupKT /get/all endpoint
    When a client make a GET request to getall endpoint
    Then GroupKT responds with a message informing the number of countries in JSON format
    And the response must have a list of 249 countries
    And each country must have a name, alpha2_code and alpha3_code keys
    And the countries returned should match the known country list
    And the response headers must match the expected
    And validates if all messages, name, alpha_2code and alpha3_code are encoded correctly

  Scenario: Check GroupKT /get/all endpoint with POST
    When a client make a POST request to getall endpoint
    Then GroupKT responds with a 200

  Scenario: Check GroupKT /get/all endpoint with PUT
    When a client make a PUT request to getall endpoint
    Then GroupKT responds with a 405 - Method Not Allowed

  Scenario: Check GroupKT /get/all endpoint with PATCH
    When a client make a PATCH request to getall endpoint
    Then GroupKT responds with a 405 - Method Not Allowed

