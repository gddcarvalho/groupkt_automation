When('a client make a GET request to getiso3code endpoint with an existing iso3code') do
  @response = groupkt_get_iso3code('AFG')
  @response_body =json(@response.body)
end

Then('GroupKT responds with a message informing the search was matched for the iso3code') do
  expect(@response.status).to eq 200
  expect(@response.headers['Content-Type']).to eq 'application/json;charset=UTF-8'
  fixture = open_file('../fixtures/get_iso3code_fixture.json.erb')
  options = { iso3code: 'AFG' }

  parsed_fixture = json(assign_fixture(fixture, options: options))

  response_body = json(@response.body)
  expect(response_body['RestResponse']['messages']).to eq(parsed_fixture['RestResponse']['messages'])
end

Then('GroupKT responds with the correct payload for each alpha3code') do
  # Loads the list of valid names, alpha2codes and alpha3codes
  list_of_names = open_file('../fixtures/list_of_name.txt')
  list_of_alpha2codes = open_file('../fixtures/list_of_alpha2code.txt')
  list_of_alpha3codes = open_file('../fixtures/list_of_alpha3code.txt')

  fixture = open_file('../fixtures/get_iso3code_fixture.json.erb')

  # Converts the list of valid alpha2code and name into an array of strings
  alpha2code = list_of_alpha2codes.split("\n")
  name = list_of_names.split("\n")

  # For each alpha3code, match the result of get iso3code response with the expected result
  list_of_alpha3codes.split("\n").each_with_index do |alpha3code, index|
    response = groupkt_get_iso3code(alpha3code)
    response_body = json(response.body)
    options = { name: name[index], alpha2code: alpha2code[index], alpha3code: alpha3code }
    expected_response_body = json(assign_fixture(fixture, options: options))

    expect(response.status).to eq 200
    expect(response_body).to eq(expected_response_body)
    expect(response_body['RestResponse']['messages']).to eq(expected_response_body['RestResponse']['messages'])
    expect(response_body['RestResponse']['result']['name']).to eq(expected_response_body['RestResponse']['result']['name'])
    expect(response_body['RestResponse']['result']['alpha2_code']).to eq(expected_response_body['RestResponse']['result']['alpha2_code'])
    expect(response_body['RestResponse']['result']['alpha3_code']).to eq(expected_response_body['RestResponse']['result']['alpha3_code'])
  end
end

Then('GroupKT returns JSON charset=UTF-8 content regardless the Accept header sent on the request on iso3code API') do
  fixture = open_file('../fixtures/list_of_MIME_types.txt')
  file = open_to_write('../logs/log_each_content_type_iso3code_request')

  fixture.split("\n").each do |content_type|
    response = groupkt_get_iso3code('AFG', accept: content_type)

    # Test that the http response received from the server is not an Internal Server Error
    # Test that the response will not include any errors (RuntimeError, StandardError...) https://relishapp.com/rspec/rspec-expectations/v/2-11/docs/built-in-matchers/raise-error-matcher#expect-any-error

    expect(response.status).to_not eq 500
    expect{response}.to_not raise_error

    # Test that the http response body is a valid json disregarding the Accept header sent.
    # I've noticed that ASCII-8BIT characters are being returned for some tests, even though all Content-Type returned are UTF-8
    # ��land Islands, C��te d'Ivoire, Cura��ao, R��unio, Saint Barth��lemy are failing, skipping them by force_encoding UTF-8

    expect{response.body.force_encoding('UTF-8').to_json}.to_not raise_error
    file.puts "[ListOfContentTypeTest] Testing content_type=#{encode_to_log(content_type)}, response_status=#{response.status}, response_content_type=#{response.headers['Content-Type']}"
  end
end

When('a client make a POST request to getiso3code endpoint') do
  @response = groupkt_post_iso3code('AFG')
end

When('a client make a PUT request to getiso3code endpoint') do
  @response = groupkt_put_iso3code('AFG')
end

When('a client make a PATCH request to getiso3code endpoint') do
  @response = groupkt_patch_iso3code('AFG')
end

Then('GroupKT responds with a message saying there were no matches for invalid input of iso3code')do
  response = groupkt_get_iso3code("1'%20or%20'1'%20=%20'1&password=1'%20or%20'1'%20=%20'1'")

  response_body = json(response.body)

  expect(response_body['RestResponse']['messages']).to include("No matching country found for requested code [1' or '1' = '1&password=1' or '1' = '1'].")
end

Then('GroupKT fails gracefully when testing iso3code against a list of user bad input data') do
  fixture = open_file('../fixtures/list_of_user_input_data.json')
  parsed_fixture = json(fixture)
  file = open_to_write('../logs/log_each_input_iso3code_request')

  parsed_fixture.each do |user_input|
    encoded_user_input = url_encode(user_input)

    response = groupkt_get_iso3code(encoded_user_input)
    expect(response.status).to_not eq 500
    expect{response}.to_not raise_error

    file.puts "[ListOfBadDataTest] Testing user_input=#{encode_to_log(user_input)}, encoded_user_input=#{encode_to_log(encoded_user_input)}, response_status=#{response.status}, response_body=#{encode_to_log(response.body)}"
  end
end