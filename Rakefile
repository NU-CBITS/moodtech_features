# filename: Rakefile

# load development version of think_feel_do_so locally

desc 'Setting database and starting think_feel_do_so for testing locally'

task :load_tfdso_local do
  Dir.chdir('/Users/Chris/Work/think_feel_do_so') do
    system('rake db:drop db:create db:migrate')
    system('rake selenium_seed:with_fixtures')
    system('rails s')
  end
end


# load development version of think_feel_do_so on staging, keeping selenium
# as driver

desc 'Set test database for testing on staging and keep driver'

task :load_tfdso_selenium do
  system('export Base_URL=https://moodtech-staging.cbits.northwestern.edu')
  Dir.chdir('/Users/Chris/Work/think_feel_do_so') do
    system('cap staging deploy:use_test_db')
    system('cap staging deploy:clean_db')
    system('cap staging deploy:migrate')
    system('cap staging deploy:seed_db')
  end
end


# load development version of think_feel_do_so on staging and switch driver 
# to sauce

desc 'Set test database for testing on staging and switch driver'

task :load_tfdso_sauce do
  system('export Base_URL=https://moodtech-staging.cbits.northwestern.edu')
  system('export Sauce=true')
  Dir.chdir('/Users/Chris/Work/think_feel_do_so') do
    system('cap staging deploy:use_test_db')
    system('cap staging deploy:clean_db')
    system('cap staging deploy:migrate_db')
    system('cap staging deploy:seed_db')
  end
end


# load staging version of think_feel_do_so on staging

desc 'Returning staging database on staging'

task :load_tfdso_staging do
  Dir.chdir('/Users/Chris/Work/think_feel_do_so') do
    system('cap staging deploy:use_staging_db')
  end
end
