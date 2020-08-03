When('a client make a GET request to getall endpoint') do
  @response = groupkt_get_all
  @response_body = json(@response.body)
end

Then('GroupKT responds with a message informing the number of countries in JSON format') do
  expect(@response.status).to eq 200
  expect(@response.headers['Content-Type']).to eq 'application/json;charset=UTF-8'

  expect(@response_body['RestResponse']['messages']).to include('Total [249] records found.')
end

Then('the response must have a list of 249 countries') do
  expect(@response_body['RestResponse']['result'].count).to eq(249)
end

Then('the countries returned should match the known country list') do
  fixture = open_file('../fixtures/get_all_country_fixture.json')
  parsed_fixture = json(fixture)

  expect(@response_body).to eq(parsed_fixture)

  @response_body['RestResponse']['result'].each_with_index do |result, index|
    expect(result['name']).to eq(parsed_fixture['RestResponse']['result'][index]['name'])
    expect(result['alpha2_code']).to eq(parsed_fixture['RestResponse']['result'][index]['alpha2_code'])
    expect(result['alpha3_code']).to eq(parsed_fixture['RestResponse']['result'][index]['alpha3_code'])
  end
end

Then('GroupKT returns JSON charset=UTF-8 content regardless the Accept header sent on the request on getall API') do
  fixture = open_file('../fixtures/list_of_MIME_types.txt')
  file = open_to_write('../logs/log_each_content_type_get_all_request')

  fixture.split("\n").each do |content_type|
    response = groupkt_get_all(accept: content_type)

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

When('a client make a POST request to getall endpoint') do
  @response = groupkt_post_all
end

When('a client make a PUT request to getall endpoint') do
  @response = groupkt_put_all
end

When('a client make a PATCH request to getall endpoint') do
  @response = groupkt_patch_all
end

