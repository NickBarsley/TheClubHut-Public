    desc "rebuild the database from scratch"

    task :rebuild=> :environment do
    p "Beggining the rebuild"
    Rake::Task["db:drop_and_create"].invoke
    Rake::Task["db:migrate"].invoke
    Rake::Task["db:populate"].invoke
    end

    desc "destroy your database"

    task :drop_and_create=> :environment do
    db_name = ActiveRecord::Base.connection.current_database
    p "Dropping the database"
    ActiveRecord::Base.connection.drop_database(db_name)
    p "Creating the database"
    ActiveRecord::Base.connection.create_database(db_name)

    db_config = YAML.load_file(File.join(RAILS_ROOT, "config", "database.yml"))
    ActiveRecord::Base.establish_connection(db_config[RAILS_ENV])
    end 