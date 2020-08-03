Feature: GroupKT iso2code, iso3code, /search/text validation against list of really bad user input data and valid content types
  As a way to verify the integrity of GroupKT /get/iso2code API,
  and /get/iso3code API,
  and /search/text API,
  As a tester,
  I want to input some really bad user data on search fields, and verify the APIs behavior,
  I want to send different Accept requests, and verify the APIs behavior

  @list_tests @bad_input
  Scenario: Check GroupKT /get/iso2code endpoint against user input data
    When a client make a GET request to getiso2code endpoint with an existing iso2code
    Then GroupKT fails gracefully when testing a list of user bad input data

  @list_tests @bad_input
  Scenario: Check GroupKT /get/iso3code endpoint against user input data
    When a client make a GET request to getiso3code endpoint with an existing iso3code
    Then GroupKT fails gracefully when testing iso3code against a list of user bad input data

  @list_tests @bad_input
  Scenario: Check GroupKT /search/text endpoint against user input data
    When a client make a GET request to searchtext endpoint with given text
    Then GroupKT fails gracefully when searching countries against a list of user bad input data

  @list_tests @content_type
  Scenario: Check GroupKT /get/all endpoint with different content type headers
    When a client make a GET request to getall endpoint
    Then GroupKT returns JSON charset=UTF-8 content regardless the Accept header sent on the request on getall API

  @list_tests @content_type
  Scenario: Check GroupKT /get/iso2code endpoint with different content type headers
    When a client make a GET request to getiso2code endpoint with an existing iso2code
    Then GroupKT returns JSON charset=UTF-8 content regardless the Accept header sent on the request on iso2code API

  @list_tests @content_type
  Scenario: Check GroupKT /get/iso3code endpoint with different content type headers
    When a client make a GET request to getiso3code endpoint with an existing iso3code
    Then GroupKT returns JSON charset=UTF-8 content regardless the Accept header sent on the request on iso3code API

  @list_tests @content_type
  Scenario: Check GroupKT /search/text endpoint with different content type headers
    When a client make a GET request to searchtext endpoint with given text
    Then GroupKT returns JSON charset=UTF-8 content regardless the Accept header sent on the request on search text API
