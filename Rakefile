# filename: Rakefile

# load development version of think_feel_do_so locally

desc 'Set and start think_feel_do_so for full suite testing locally'

task :load_tfdso_local do
  Dir.chdir('/Users/Chris/Work/think_feel_do_so') do
    system('rake db:drop db:create db:migrate')
    system('rake selenium_seed:with_fixtures')
    system('rake goal_tasks:share_past_due')
    system('rails s')
  end
end


# dump database

desc 'Dump database'

task :dump_db do
  system '/Applications/Postgres.app/Contents/Versions/9.3/bin/pg_dump ' \
         '-c -C -o -U Chris think_feel_do_so_development -f ' \
         '/Users/Chris/Work/dbs/tfdso_db.sql'
end


# load database with data from database dump

desc 'Restore database'

task :restore_db do
  system('/Applications/Postgres.app/Contents/Versions/9.3/bin/dropdb ' \
         'think_feel_do_so_development')
  system('/Applications/Postgres.app/Contents/Versions/9.3/bin/createdb ' \
         'think_feel_do_so_development')
  system('/Applications/Postgres.app/Contents/Versions/9.3/bin/psql -U ' \
         'Chris -d think_feel_do_so_development -f ' \
         '/Users/Chris/Work/dbs/tfdso_db.sql')
  Dir.chdir('/Users/Chris/Work/think_feel_do_so') do
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
    system('cap staging deploy:seed_selenium_db')
    system('rake goal_tasks:share_past_due')
  end
end

# If there are errors you may need to run:
# ssh deploy@moodtech-staging.cbits.northwestern.edu "pg_dump -h
#  localhost -d tfdo_aux -U tfdo_user -f
#  /var/www/apps/think_feel_do_so/shared/db/clean.sql -c"
#
# then you will need to hand clean (remove all CREATE table blocks at 
# bottom of file): /var/www/apps/think_feel_do_so/shared/db/clean.sql
# by opening it using vi after ssh-ing into the server:
# ssh deploy@moodtech-staging.cbits.northwestern.edu


# load development version of think_feel_do_so on staging and switch driver 
# to sauce

desc 'Set test database for testing on staging and switch driver'

task :load_tfdso_sauce do
  system('export Base_URL=https://moodtech-staging.cbits.northwestern.edu')
  system('Sauce=true')
  Dir.chdir('/Users/Chris/Work/think_feel_do_so') do
    system('cap staging deploy:use_test_db')
    system('cap staging deploy:clean_db')
    system('cap staging deploy:migrate_db')
    system('cap staging deploy:seed_selenium_db')
    system('rake goal_tasks:share_past_due')
  end
end


# load staging version of think_feel_do_so on staging

desc 'Returning staging database on staging'

task :load_tfdso_staging do
  Dir.chdir('/Users/Chris/Work/think_feel_do_so') do
    system('cap staging deploy:use_staging_db')
  end
end
