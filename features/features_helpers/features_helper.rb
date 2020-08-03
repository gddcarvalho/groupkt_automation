require 'byebug'
require 'faraday'
require 'erubis'

module FeaturesHelper
  # Method used to handle ASCII-8BIT to UTF-8 (Encoding::UndefinedConversionError)
  # ��land Islands, C��te d'Ivoire, Cura��ao, R��unio, Saint Barth��lemy
  def convert_to_utf8_and_validate(encoded_string)
    encoded_string.force_encoding('UTF-8').valid_encoding?
  end

  def open_file(file_path)
    File.read(File.join(File.dirname(__FILE__), file_path))
  end

  def json(parse_this)
    JSON.parse(parse_this)
  end

  # Used to encode bad user input tests into URI compliance format #http://www.ietf.org/rfc/rfc2396.txt
  def url_encode(query_string)
    CGI.escape(query_string)
  end

  def assign_fixture(fixture, options:nil)
    Erubis::Eruby.new(fixture).result(options)
  end

  #"\xEF" from ASCII-8BIT to UTF-8 (Encoding::UndefinedConversionError)
  def encode_to_log(this)
    this.encode('UTF-8', invalid: :replace, undef: :replace, replace: '').force_encoding('UTF-8')
  end

  def open_to_write(log)
    File.open(File.join(File.dirname(__FILE__), log), 'w')
  end

  def url
    'http://services.groupkt.com'
  end

  #'http://services.groupkt.com/country/get/all' API calls

  def groupkt_get_all(accept: nil)
    conn = Faraday.new(:url => url) do |builder|
      builder.request :retry, max: 2, interval: 0.05,
                      interval_randomness: 0.5, backoff_factor: 2,
                      exceptions: [Faraday::ConnectionFailed, Faraday::ClientError]
      builder.adapter Faraday.default_adapter
    end

    response = conn.get '/country/get/all', {}, {'Accept' => accept}
    response
  end

  def groupkt_post_all(accept: nil)
    conn = Faraday.new(:url => url) do |builder|
      builder.request :retry, max: 2, interval: 0.05,
                      interval_randomness: 0.5, backoff_factor: 2,
                      exceptions: [Faraday::ConnectionFailed, Faraday::ClientError]
      builder.adapter Faraday.default_adapter
    end

    response = conn.post '/country/get/all' do |req|
      req.headers['Accept'] = accept
    end
    response
  end

  def groupkt_put_all(accept: nil)
    conn = Faraday.new(:url => url) do |builder|
      builder.request :retry, max: 2, interval: 0.05,
                      interval_randomness: 0.5, backoff_factor: 2,
                      exceptions: [Faraday::ConnectionFailed, Faraday::ClientError]
      builder.adapter Faraday.default_adapter
    end

    response = conn.put '/country/get/all' do |req|
      req.headers['Accept'] = accept
    end
    response
  end

  def groupkt_patch_all(accept: nil)
    conn = Faraday.new(:url => url) do |builder|
      builder.request :retry, max: 2, interval: 0.05,
                      interval_randomness: 0.5, backoff_factor: 2,
                      exceptions: [Faraday::ConnectionFailed, Faraday::ClientError]
      builder.adapter Faraday.default_adapter
    end

    response = conn.patch '/country/get/all' do |req|
      req.headers['Accept'] = accept
    end
    response
  end

  #'http://services.groupkt.com/country/get/#{alpha2_code}' API calls

  def groupkt_get_iso2code(alpha2_code, accept: nil)
    conn = Faraday.new(:url => url) do |builder|
      builder.request :retry, max: 2, interval: 0.05,
                      interval_randomness: 0.5, backoff_factor: 2,
                      exceptions: [Faraday::ConnectionFailed, Faraday::ClientError]
      builder.adapter Faraday.default_adapter
    end

    response = conn.get "/country/get/iso2code/#{alpha2_code}", {}, {'Accept' => accept}
    response
  end

  def groupkt_post_iso2code(alpha2_code, accept: nil)
    conn = Faraday.new(:url => url) do |builder|
      builder.request :retry, max: 2, interval: 0.05,
                      interval_randomness: 0.5, backoff_factor: 2,
                      exceptions: [Faraday::ConnectionFailed, Faraday::ClientError]
      builder.adapter Faraday.default_adapter
    end

    response = conn.post "/country/get/iso2code/#{alpha2_code}" do |req|
      req.headers['Accept'] = accept
    end
    response
  end

  def groupkt_put_iso2code(alpha2_code, accept: nil)
    conn = Faraday.new(:url => url) do |builder|
      builder.request :retry, max: 2, interval: 0.05,
                      interval_randomness: 0.5, backoff_factor: 2,
                      exceptions: [Faraday::ConnectionFailed, Faraday::ClientError]
      builder.adapter Faraday.default_adapter
    end

    response = conn.put "/country/get/iso2code/#{alpha2_code}" do |req|
      req.headers['Accept'] = accept
    end
    response
  end

  def groupkt_patch_iso2code(alpha2_code, accept: nil)
    conn = Faraday.new(:url => url) do |builder|
      builder.request :retry, max: 2, interval: 0.05,
                      interval_randomness: 0.5, backoff_factor: 2,
                      exceptions: [Faraday::ConnectionFailed, Faraday::ClientError]
      builder.adapter Faraday.default_adapter
    end

    response = conn.patch "/country/get/iso2code/#{alpha2_code}" do |req|
      req.headers['Accept'] = accept
    end
    response
  end

  #'http://services.groupkt.com/country/get/#{alpha3_code}' API calls

  def groupkt_get_iso3code(alpha3_code, accept: nil)
    conn = Faraday.new(:url => url) do |builder|
      builder.request :retry, max: 2, interval: 0.05,
                      interval_randomness: 0.5, backoff_factor: 2,
                      exceptions: [Faraday::ConnectionFailed, Faraday::ClientError]
      builder.adapter Faraday.default_adapter
    end

    response = conn.get "/country/get/iso3code/#{alpha3_code}", {}, {'Accept' => accept}
    response
  end

  def groupkt_post_iso3code(alpha3_code, accept: nil)
    conn = Faraday.new(:url => url) do |builder|
      builder.request :retry, max: 2, interval: 0.05,
                      interval_randomness: 0.5, backoff_factor: 2,
                      exceptions: [Faraday::ConnectionFailed, Faraday::ClientError]
      builder.adapter Faraday.default_adapter
    end

    response = conn.post "/country/get/iso3code/#{alpha3_code}" do |req|
      req.headers['Accept'] = accept
    end
    response
  end

  def groupkt_put_iso3code(alpha3_code, accept: nil)
    conn = Faraday.new(:url => url) do |builder|
      builder.request :retry, max: 2, interval: 0.05,
                      interval_randomness: 0.5, backoff_factor: 2,
                      exceptions: [Faraday::ConnectionFailed, Faraday::ClientError]
      builder.adapter Faraday.default_adapter
    end

    response = conn.put "/country/get/iso3code/#{alpha3_code}" do |req|
      req.headers['Accept'] = accept
    end
    response
  end

  def groupkt_patch_iso3code(alpha3_code, accept: nil)
    conn = Faraday.new(:url => url) do |builder|
      builder.request :retry, max: 2, interval: 0.05,
                      interval_randomness: 0.5, backoff_factor: 2,
                      exceptions: [Faraday::ConnectionFailed, Faraday::ClientError]
      builder.adapter Faraday.default_adapter
    end

    response = conn.patch "/country/get/iso3code/#{alpha3_code}" do |req|
      req.headers['Accept'] = accept
    end
    response
  end

  #'http://services.groupkt.com/country/search?text=#{text2search}' API calls

  def groupkt_search_country(text2search, accept: nil)
    conn = Faraday.new(:url => url) do |builder|
      builder.request :retry, max: 2, interval: 0.05,
                      interval_randomness: 0.5, backoff_factor: 2,
                      exceptions: [Faraday::ConnectionFailed, Faraday::ClientError]
      builder.adapter Faraday.default_adapter
    end

    response = conn.get "/country/search?text=#{text2search}", {}, {'Accept' => accept}
    response
  end

  def groupkt_search_country_with_post(text2search, accept: nil)
    conn = Faraday.new(:url => url) do |builder|
      builder.request :retry, max: 2, interval: 0.05,
                      interval_randomness: 0.5, backoff_factor: 2,
                      exceptions: [Faraday::ConnectionFailed, Faraday::ClientError]
      builder.adapter Faraday.default_adapter
    end

    response = conn.post "/country/search?text=#{text2search}" do |req|
      req.headers['Accept'] = accept
    end
    response
  end

  def groupkt_search_country_with_put(text2search, accept: nil)
    conn = Faraday.new(:url => url) do |builder|
      builder.request :retry, max: 2, interval: 0.05,
                      interval_randomness: 0.5, backoff_factor: 2,
                      exceptions: [Faraday::ConnectionFailed, Faraday::ClientError]
      builder.adapter Faraday.default_adapter
    end

    response = conn.put "/country/search?text=#{text2search}" do |req|
      req.headers['Accept'] = accept
    end
    response
  end

  def groupkt_search_country_with_patch(text2search, accept: nil)
    conn = Faraday.new(:url => url) do |builder|
      builder.request :retry, max: 2, interval: 0.05,
                      interval_randomness: 0.5, backoff_factor: 2,
                      exceptions: [Faraday::ConnectionFailed, Faraday::ClientError]
      builder.adapter Faraday.default_adapter
    end

    response = conn.patch "/country/search?text=#{text2search}" do |req|
      req.headers['Accept'] = accept
    end
    response
  end
end