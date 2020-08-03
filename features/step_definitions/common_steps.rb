include FeaturesHelper

Then('GroupKT responds with a 200') do
  expect(@response.status).to eq 200
  expect(@response.headers['Content-Type']).to eq 'text/html;charset=UTF-8'
  expect(@response.body).to include('Java web development tutorials')
end

Then('GroupKT responds with a 405 - Method Not Allowed') do
  expect(@response.status).to eq 405
  expect(@response.headers['Content-Type']).to eq 'text/html;charset=UTF-8'
  expect(@response.body.force_encoding('UTF-8')).to include('HTTP Status 405 – Method Not Allowed')
end

When('a client make a request to a resource not found') do
  @response = groupkt_get_iso2code('%3Ca+href%3D%22%5Cx0Bjavascript%3Ajavascript%3Aalert%281%29%22+id%3D%22fuzzelement1%22%3Etest%3C%2Fa%3E')
end

When('a client make a request that results in Bad Request') do
  @response = groupkt_get_iso2code('ABC%3Cdiv+style%3D%22x%5Cx3Aexpression%28javascript%3Aalert%281%29%22%3EDEF')
end

Then('GroupKT responds with a 404 - Not Found') do
  expect(@response.body.force_encoding('UTF-8')).to include('404 Not Found')
end

Then('GroupKT responds with a 400 - Bad Request') do
  expect(@response.status).to eq 400
end

Then('the response headers must match the expected') do
  expect(@response.headers['Cache-Control']).to eq 'no-cache, no-store, max-age=0, must-revalidate'
  expect(@response.headers['Pragma']).to eq 'no-cache'
  expect(@response.headers['Server']).to eq 'Apache/2.4.25 (Debian)'
  expect(@response.headers['Transfer-Encoding']).to eq 'chunked'
  expect(@response.headers['X-Content-Type-Options']).to eq 'nosniff'
  expect(@response.headers['X-Frame-Options']).to eq 'DENY'
  expect(@response.headers['X-XSS-Protection']).to eq '1; mode=block'
end

Then('each country must have a name, alpha2_code and alpha3_code keys') do
  @response_body['RestResponse']['result'].each do |result|
    expect(result.keys).to contain_exactly('name', 'alpha2_code', 'alpha3_code')
  end
end

Then('the returned country must have a name, alpha2_code and alpha3_code keys') do
  expect(@response_body['RestResponse']['result'].keys).to contain_exactly('name', 'alpha2_code', 'alpha3_code')
end

Then('validates if all messages, name, alpha_2code and alpha3_code are encoded correctly') do
  @response_body['RestResponse']['messages'].each do |messages|
    expect(convert_to_utf8_and_validate(messages)).to be true
  end

  @response_body['RestResponse']['result'].each do |result|
    expect(convert_to_utf8_and_validate(result['name'])).to be true
    expect(result['alpha2_code'].valid_encoding?).to be true
    expect(result['alpha3_code'].valid_encoding?).to be true
  end
end

Then('validates if all messages, name, alpha_2code and alpha3_code are encoded correctly on iso2code and iso3code apis') do
  @response_body['RestResponse']['messages'].each do |messages|
    expect(convert_to_utf8_and_validate(messages)).to be true
  end

  expect(convert_to_utf8_and_validate(@response_body['RestResponse']['result']['name'])).to be true
  expect(@response_body['RestResponse']['result']['alpha2_code'].valid_encoding?).to be true
  expect(@response_body['RestResponse']['result']['alpha3_code'].valid_encoding?).to be true
end
