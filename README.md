# GroupKT Automation

This project contains an automation suite that uses cucumber to describe test scenarios, faraday to perform API calls, rspec-expectations to assert test results and webmock that is being used to mock unit tests.

This project was developed in Ruby.

There are many different ways of installing [Ruby](https://www.ruby-lang.org/en/).

The way I suggest is by installing [RVM (Ruby Version Manager)](https://rvm.io/rvm/install) and with it install the desired Ruby version.

You can find a guided step by step on how to accomplish this on [RVM page](https://rvm.io/rvm/install).

If you opted to install RVM, you can use it to install Ruby. 

This project works best with Ruby `2.4.1` and you can install it by running the following command: 
```
$ rvm install ruby-2.4.1
```

After installing Ruby and downloading this repository, cd to the project directory: 

```
$ cd groupkt_automation
```

Install the necessary gems that are used to run the tests: 
```
$ gem install bundler
$ bundle install
```

## External Libs/Gems
- [cucumber](https://rubygems.org/gems/cucumber)
- [rspec-expectations](https://rubygems.org/gems/rspec-expectations)
- [rake](https://rubygems.org/gems/rake)
- [rspec](https://rubygems.org/gems/rspec)
- [faraday](https://rubygems.org/gems/faraday)
- [byebug](https://rubygems.org/gems/byebug)
- [erubis](https://rubygems.org/gems/erubis)
- [webmock](https://rubygems.org/gems/webmock)

## Folders Structure
- Cucumber features can be found inside ```features/acceptance_tests```
- Steps definitions for cucumber features and the code used to validate features can be found inside ```features/step_definitions```
- Fixtures that are used in steps definitions and unit tests can be found inside ```features/fixtures```
- All Faraday requests to the different APIs and support methods can be found inside ```features/feature_helpers```
- Logs will be stored in ```features/logs``` folder
- Unit tests for the support methods can be found inside ```spec/features/features_helpers```

## Configuration

### How to run the test suite

From inside the project root path (```$ cd groupkt_automation```) the following commands are accepted:

| Command | Description |
| --- | --- |
| rake do_it | Execute all tests but bad_user_input and content_type tests |
| rake do_it_all| Execute all tests |
| rake get_all_countries| Execute all get countries |
| rake get_iso2code     | Execute all get iso2code tests |
| rake get_iso3code     | Execute all get iso3code tests |
| rake search_countries | Execute all get search countries tests |
| rake bad_user_input   | Execute 485 tests of bad data (```/fixtures/list_of_user_input_data.json```) against each endpoint that accept user input |
| rake content_type     | Execute 1248 tests of all [iana.org](https://www.iana.org/form/media-types) MIME types (```/fixtures/list_of_MIME_types.txt```) against each endpoint |
| rake lists            | Execute both bad user input and content type tests
| rspec                 | Run unit tests located inside ```spec``` folder |

## Known Limitation

### About list tests
The list tests (```rake bad_user_input```, ```rake content_type``` and ```rake lists```) can take some time until they're finished. During this time, the tester will not receive any instant feedback. In order to address this and to know exactly which tests are running in real time, the requests and the responses are going to be logged to files in  ```features/logs``` folder.

You can ```tail -f``` the log of interest and you will start seeing the requests that are being made in background while the tests are running:
  
![alt tag](https://i.imgur.com/6iCcBhu.jpg)
![alt tag](https://i.imgur.com/ZxyqeNh.jpg)

### About Multiple Encodes

Regarding ��land Islands, C��te d'Ivoire, Cura��ao, R��unio and Saint Barth��lemy.

An ```Encoding::UndefinedConversionError``` error was  being raised when attempting to parse GroupKT response body (```['RestResponse']['result']['name']```) for those countries.

That was happening because the mentioned countries have ASCII-8BIT characters, and the JSON format expects UTF-8 as per RFC 4627.

These are the conditions that need to be met in order to reproduce this behavior:

```
When making a Request to /get/all endpoint, 
And Request Accept Header includes 'json' 
Ex:

'Accept': "application/alto-costmap+json" Header

The Response Content-Type Header will include:

'Content-Type': "application/alto-costmap+json;charset=UTF-8"

And the Response Body will include:

"\xEF\xBF\xBD\xEF\xBF\xBDland Islands\"
"C\xEF\xBF\xBD\xEF\xBF\xBDte d'Ivoire\"
"Cura\xEF\xBF\xBD\xEF\xBF\xBDao\"
"R\xEF\xBF\xBD\xEF\xBF\xBDunion\"
"Saint Barth\xEF\xBF\xBD\xEF\xBF\xBDlemy\"

Which will raise: 

#<Encoding::UndefinedConversionError: "\xEF" from ASCII-8BIT to UTF-8>

When Attempting to parse the Response Body to JSON format
```

References: 

"The MIME media type for JSON text is ```application/json```. The default encoding is ```UTF-8```." (Source: [RFC 4627](http://www.ietf.org/rfc/rfc4627.txt)).

"The ```"Content-Type"``` header field indicates the media type of the associated representation: either the representation enclosed in the message payload or the selected representation, as determined by the message semantics.  The indicated media type defines both the data format and how that data is intended to be processed." (Source: [RFC 7231 section-3.1.1.5](https://tools.ietf.org/html/rfc7231#section-3.1.1.5)

"The ```406 (Not Acceptable)``` status code indicates that the target resource does not have a current representation that would be acceptable to the user agent, according to the proactive negotiation header fields received in the request ([Section 5.3](https://tools.ietf.org/html/rfc7231#section-5.3)." (Source: [RFC 7231 section-6.5.6](https://tools.ietf.org/html/rfc7231#section-6.5.6)).

The issue mentioned above is being addressed with a workaround that force encodes UTF-8 to the responses that contains such characters. For this reason, no failures will be seen when running this test suite. You can undo this workaround by removing ```force_encoding('UTF-8')``` from where it's being applied and also removing this [method](https://github.com/gddcarvalho/groupkt_automation/blob/master/features/features_helpers/features_helper.rb#L8) from [features_helper](https://github.com/gddcarvalho/groupkt_automation/blob/master/features/features_helpers/features_helper.rb).
