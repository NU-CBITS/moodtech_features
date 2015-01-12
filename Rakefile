#filename: Rakefile

#load development version of think_feel_do_so locally

desc "Setting database and starting think_feel_do_so for testing locally"

task :load_tfdso_local do
  Dir.chdir('/Users/Chris/Work/think_feel_do_so') do
    system( "rake db:drop db:create db:migrate" )
    system( "rake seed:with_fixtures" )
    system( "rails s" )
  end
end


#load development version of think_feel_do_so on staging

desc "Setting test database for testing on staging"

task :load_tfdso_test do
  Dir.chdir('User/Chris/Work/think_feel_do_so') do
    system( "cap staging deploy:use_test_db" )
    system( "cap staging deploy:clean_db" )
    system( "cap staging deploy:migrate_db" )
    system( "cap staging deploy:seed_db" )
  end
end


#load staging version of think_feel_do_so on staging

desc "Returning staging database on staging"

task :load_tfdso_staging do
  Dir.chdir('User/Chris/Work/think_feel_do_so') do
    system( "cap staging deploy:use_staging_db" )
  end
end