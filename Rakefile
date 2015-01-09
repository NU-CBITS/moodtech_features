#filename: Rakefile

desc "Setting database and starting think_feel_do_so for testing locally"

#These are take to load development version of think_feel_do_so locally

task :load_tfdso_local do
  Dir.chdir('/Users/Chris/Work/think_feel_do_so') do
    system( "rake db:drop db:create db:migrate" )
    system( "rake seed:with_fixtures" )
    system( "rails s" )
  end
end
