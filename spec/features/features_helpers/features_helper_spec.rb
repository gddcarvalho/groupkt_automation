describe FeaturesHelper, type: :helper do
  let(:described_class) { Class.new { extend FeaturesHelper } }

  describe 'Validates features_helper support methods' do
    describe 'support methods' do
      context '#convert_to_utf8_and_validate' do
        let(:valid_string) { '��land Islands' }
        let(:invalid_string) { "\xEF\\" }

        it 'Converts a string to UTF-8 and validate its encoding' do
          expect(described_class.convert_to_utf8_and_validate("\xEF\xBF\xBD\xEF\xBF\xBDland Islands\\")).to be true
          expect(described_class.convert_to_utf8_and_validate("C\xEF\xBF\xBD\xEF\xBF\xBDte d'Ivoire\\")).to be true
          expect(described_class.convert_to_utf8_and_validate("Cura\xEF\xBF\xBD\xEF\xBF\xBDao\\")).to be true
          expect(described_class.convert_to_utf8_and_validate("R\xEF\xBF\xBD\xEF\xBF\xBDunion\\")).to be true
          expect(described_class.convert_to_utf8_and_validate("Saint Barth\xEF\xBF\xBD\xEF\xBF\xBDlemy\\")).to be true
        end

        it 'Returns true for a string encoded correctly.' do
          expect(described_class.convert_to_utf8_and_validate(valid_string)).to be true
        end

        it 'Returns false for a string encoded incorrectly.' do
          expect(described_class.convert_to_utf8_and_validate(invalid_string)).to be false
        end

        it 'JSON parses the string correctly' do
          expect{valid_string.to_json}.to_not raise_error
        end

        it 'JSON parser explodes' do
          expect{invalid_string.to_json}.to raise_exception JSON::GeneratorError
        end
      end

      context '#open_file' do
        let(:sample_text) { 'open_file_test' }

        it 'Opens and read a file in a given path.' do
          expect(described_class.open_file('../fixtures/open_file_test.txt')).to be_truthy
        end
      end

      context '#url_encode' do
        let(:string_to_encode) { "\"`'><script>\\x0Bjavascript:alert(1)</script>" }

        it 'Encode a string with CGI' do
          expect(described_class.url_encode(string_to_encode)).to eq ('%22%60%27%3E%3Cscript%3E%5Cx0Bjavascript%3Aalert%281%29%3C%2Fscript%3E')
        end
      end

      context '#assign_fixture' do
        let(:options) {{ name: 'who', alpha2code: 'watches', alpha3code: 'the watchman' }}
        let(:fixture) { File.read(File.join(File.dirname(__FILE__), '../../../features/fixtures/get_iso2code_fixture.json.erb')) }
        let(:expected_fixture) {
          {
              'RestResponse' => {
                  'messages' => [ 'Country found matching code [watches].' ],
                  'result' => {
                      'name' => 'who',
                      'alpha2_code' => 'watches',
                      'alpha3_code' => 'the watchman'
                  }
              }
          }
        }

        it 'Assigns values to embedded Ruby' do
          expect(JSON.parse(described_class.assign_fixture(fixture, options: options))).to eq(expected_fixture)
        end
      end

      context '#encode_to_log' do
        let(:sample_text) { '\xEF' }

        it 'Forces encoding replacement to '' so it can log correctly' do
          expect(described_class.encode_to_log(sample_text)).to eq '\\xEF'
        end
      end

      context '#open_to_write' do
        let(:sample_text) { 'who watches the watchman' }

        it 'Opens and write to a file in a given path.' do
          expect(described_class.open_file('../fixtures/open_file_test.txt')).to include(sample_text)

          file = described_class.open_to_write('../fixtures/open_file_test.txt')
          file << sample_text
          end
      end

      context '#url' do
        let(:expected_url) { 'http://services.groupkt.com' }

        it 'returns GroupKT base url' do
          expect(described_class.url).to eq expected_url
        end
      end
    end

    describe 'web services' do
      before(:each) do
        stub_request(:get, 'http://services.groupkt.com/country/get/all')
        stub_request(:post, 'http://services.groupkt.com/country/get/all')
        stub_request(:put, 'http://services.groupkt.com/country/get/all')
        stub_request(:patch, 'http://services.groupkt.com/country/get/all')

        stub_request(:get, 'http://services.groupkt.com/country/get/iso2code/test')
        stub_request(:post, 'http://services.groupkt.com/country/get/iso2code/test')
        stub_request(:put, 'http://services.groupkt.com/country/get/iso2code/test')
        stub_request(:patch, 'http://services.groupkt.com/country/get/iso2code/test')

        stub_request(:get, 'http://services.groupkt.com/country/get/iso3code/test')
        stub_request(:post, 'http://services.groupkt.com/country/get/iso3code/test')
        stub_request(:put, 'http://services.groupkt.com/country/get/iso3code/test')
        stub_request(:patch, 'http://services.groupkt.com/country/get/iso3code/test')

        stub_request(:get, 'http://services.groupkt.com/country/search?text=test')
        stub_request(:post, 'http://services.groupkt.com/country/search?text=test')
        stub_request(:put, 'http://services.groupkt.com/country/search?text=test')
        stub_request(:patch, 'http://services.groupkt.com/country/search?text=test')
      end

      describe 'GroupKT get/all requests' do
        context '#groupkt_get_all' do
          it 'Makes a GET request to GroupKT /get/all endpoint' do
            response = described_class.groupkt_post_all
            expect(response.status).to eq 200
          end
        end

        context '#groupkt_get_all' do
          it 'Makes a GET request to GroupKT /get/all endpoint' do
            response = described_class.groupkt_post_all
            expect(response.status).to eq 200
          end
        end

        context '#groupkt_get_all' do
          it 'Makes a GET request to GroupKT /get/all endpoint' do
            response = described_class.groupkt_put_all
            expect(response.status).to eq 200
          end
        end

        context '#groupkt_get_all' do
          it 'Makes a GET request to GroupKT /get/all endpoint' do
            response = described_class.groupkt_patch_all
            expect(response.status).to eq 200
          end
        end
      end

      describe 'GroupKT iso2code requests' do
        context '#groupkt_get_all' do
          it 'Makes a GET request to GroupKT /get/all endpoint' do
            response = described_class.groupkt_get_iso2code('test')
            expect(response.status).to eq 200
          end
        end

        context '#groupkt_get_all' do
          it 'Makes a GET request to GroupKT /get/all endpoint' do
            response = described_class.groupkt_post_iso2code('test')
            expect(response.status).to eq 200
          end
        end

        context '#groupkt_get_all' do
          it 'Makes a GET request to GroupKT /get/all endpoint' do
            response = described_class.groupkt_put_iso2code('test')
            expect(response.status).to eq 200
          end
        end

        context '#groupkt_get_all' do
          it 'Makes a GET request to GroupKT /get/all endpoint' do
            response = described_class.groupkt_patch_iso2code('test')
            expect(response.status).to eq 200
          end
        end
      end

      describe 'GroupKT iso3code requests' do
        context '#groupkt_get_all' do
          it 'Makes a GET request to GroupKT /get/all endpoint' do
            response = described_class.groupkt_get_iso3code('test')
            expect(response.status).to eq 200
          end
        end

        context '#groupkt_get_all' do
          it 'Makes a GET request to GroupKT /get/all endpoint' do
            response = described_class.groupkt_post_iso3code('test')
            expect(response.status).to eq 200
          end
        end

        context '#groupkt_get_all' do
          it 'Makes a GET request to GroupKT /get/all endpoint' do
            response = described_class.groupkt_put_iso3code('test')
            expect(response.status).to eq 200
          end
        end

        context '#groupkt_get_all' do
          it 'Makes a GET request to GroupKT /get/all endpoint' do
            response = described_class.groupkt_patch_iso3code('test')
            expect(response.status).to eq 200
          end
        end
      end

      describe 'GroupKT search/text requests' do
        context '#groupkt_get_all' do
          it 'Makes a GET request to GroupKT /get/all endpoint' do
            response = described_class.groupkt_search_country('test')
            expect(response.status).to eq 200
          end
        end

        context '#groupkt_get_all' do
          it 'Makes a GET request to GroupKT /get/all endpoint' do
            response = described_class.groupkt_search_country_with_post('test')
            expect(response.status).to eq 200
          end
        end

        context '#groupkt_get_all' do
          it 'Makes a GET request to GroupKT /get/all endpoint' do
            response = described_class.groupkt_search_country_with_put('test')
            expect(response.status).to eq 200
          end
        end

        context '#groupkt_get_all' do
          it 'Makes a GET request to GroupKT /get/all endpoint' do
            response = described_class.groupkt_search_country_with_patch('test')
            expect(response.status).to eq 200
          end
        end
      end
    end
  end
end