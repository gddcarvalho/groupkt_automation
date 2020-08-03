# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

desc 'Execute all tests but bad_user_input tests'
task :do_it do
  exec 'bundle exec cucumber features/ -r features/ --tag ~@list_tests'
end

desc 'Execute all tests'
task :do_it_all do
  exec 'bundle exec cucumber features/ -r features/'
end

desc 'Execute all get countries'
task :get_all_countries do
  exec 'bundle exec cucumber features/acceptance_tests/get_all_countries.feature -r features/'
end

desc 'Execute all get iso2code tests'
task :get_iso2code do
  exec 'bundle exec cucumber features/acceptance_tests/get_iso2code.feature -r features/'
end

desc 'Execute all get iso3code tests'
task :get_iso3code do
  exec 'bundle exec cucumber features/acceptance_tests/get_iso3code.feature -r features/'
end

desc 'Execute all get search countries tests'
task :search_countries do
  exec 'bundle exec cucumber features/acceptance_tests/search_country.feature -r features/'
end

desc 'Execute 485 tests of bad data (/fixtures/list_of_user_input_data.json) against each endpoint that accept user input 16m23.466s'
task :bad_user_input do
  exec 'bundle exec cucumber features/acceptance_tests/test_lists.feature -r features/ --tag  @bad_input'
end

desc 'Execute 1248 tests of all iana.org MIME types (/fixtures/list_of_MIME_types.txt) against each endpoint 39m31.702s'
task :content_type do
  exec 'bundle exec cucumber features/acceptance_tests/test_lists.feature -r features/ --tag @content_type'
end

desc 'Execute both bad user input and content type tests'
task :lists do
  exec 'bundle exec cucumber features/acceptance_tests/test_lists.feature -r features/ --tag  @list_tests'
end