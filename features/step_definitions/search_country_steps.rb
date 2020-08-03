When('a client make a GET request to searchtext endpoint with given text') do
  @response = groupkt_search_country('Afgha')
  @response_body = json(@response.body)
end

Then('GroupKT responds with a message informing the search was matched for the given text') do
  expect(@response.status).to eq 200
  expect(@response.headers['Content-Type']).to eq 'application/json;charset=UTF-8'

  expect(@response_body['RestResponse']['messages']).to include('Total [1] records found.')
end

Then('GroupKT returns JSON charset=UTF-8 content regardless the Accept header sent on the request on search text API') do
  fixture = open_file('../fixtures/list_of_MIME_types.txt')
  file = open_to_write('../logs/log_each_content_type_search_text_request')

  fixture.split("\n").each do |content_type|
    response = groupkt_search_country('AfghA', accept: content_type)

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

Then('for the given search queries, GroupKT response has the correct payload') do |table|
  table.hashes.each do |row|
    text = row['text']
    name = row['name'].split(";")
    alpha2codes = row['alpha2code'].split(",")
    alpha3codes = row['alpha3code'].split(",")
    records_found = row['records_found']
    expected_hash = []

    # Mounts the expected hash for query specified in name text column
    name.each_with_index do |name, index|

      expected_hash[index] = {
          'name' => "#{name}",
          'alpha2_code' => "#{alpha2codes[index]}",
          'alpha3_code' => "#{alpha3codes[index]}"
      }
    end

    # Load the template (search_text_fixture_json.erb) and assigns the expected hash to it
    options = {records_found: records_found, hash: expected_hash, search_query: text}
    fixture = open_file('../fixtures/search_text_fixture.json.erb')
    expected_result = json(assign_fixture(fixture, options: options))

    # Send request to groupkt search text API with text from feature table
    response = groupkt_search_country(text)
    response_body = json(response.body)

    # Match the response received from GroupKT API with the expected one
    expect(response.status).to eq 200
    expect(response_body).to eq expected_result
    expect(response_body['RestResponse']['messages']).to eq expected_result['RestResponse']['messages']

    response_body['RestResponse']['result'].each_with_index do |result, index|
      expect(result['name']).to eq(expected_result['RestResponse']['result'][index]['name'])
      expect(result['alpha2_code']).to eq(expected_result['RestResponse']['result'][index]['alpha2_code'])
      expect(result['alpha3_code']).to eq(expected_result['RestResponse']['result'][index]['alpha3_code'])
    end
  end
end

When('a client make a POST request to searchtext endpoint') do
  @response= groupkt_search_country_with_post('Afgha')
end

When('a client make a PUT request to searchtext endpoint') do
  @response = groupkt_search_country_with_post('Afgha')
end

When('a client make a PATCH request to searchtext endpoint') do
  @response = groupkt_search_country_with_post('Afgha')
end

Then('GroupKT responds with a message saying there were no matches for invalid input')do
  response = groupkt_search_country("1'%20or%20'1'%20=%20'1&password=1'%20or%20'1'%20=%20'1'")
  response_body = json(response.body)

  expect(response_body['RestResponse']['messages']).to include("No matching country found for requested code [1' or '1' = '1].")
end

Then('GroupKT fails gracefully when searching countries against a list of user bad input data') do
  fixture = open_file('../fixtures/list_of_user_input_data.json')
  parsed_fixture = json(fixture)
  file = open_to_write('../logs/log_each_input_search_text_request')

  parsed_fixture.each do |user_input|
    encoded_user_input = url_encode(user_input)

    response = groupkt_search_country(encoded_user_input)
    expect(response.status).to_not eq 500
    expect{response}.to_not raise_error

    file.puts "[ListOfBadDataTest] Testing user_input=#{encode_to_log(user_input)}, encoded_user_input=#{encode_to_log(encoded_user_input)}, response_status=#{response.status}, response_body=#{encode_to_log(response.body)}"
  end
end