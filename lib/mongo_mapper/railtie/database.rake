namespace :db do

  if not Rake::Task.task_defined?("db:drop")
    desc 'Drops all the collections for the database for the current Rails.env'
    task :drop => :environment do
      MongoMapper.database.collections.select {|c| c.name !~ /system/ }.each(&:drop)
    end
  end

  if not Rake::Task.task_defined?("db:seed")
    # if another ORM has defined db:seed, don't run it twice.
    desc 'Load the seed data from db/seeds.rb'
    task :seed => :environment do
      seed_file = File.join(Rails.root, 'db', 'seeds.rb')
      load(seed_file) if File.exist?(seed_file)
    end
  end

  if not Rake::Task.task_defined?("db:setup")
    desc 'Create the database, and initialize with the seed data'
    task :setup => [ 'db:create', 'db:seed' ]
  end

  if not Rake::Task.task_defined?("db:reseed")
    desc 'Delete data and seed'
    task :reseed => [ 'db:drop', 'db:seed' ]
  end

  if not Rake::Task.task_defined?("db:create")
    task :create => :environment do
      # noop
    end
  end

  if not Rake::Task.task_defined?("db:migrate")
    task :migrate => :environment do
      # noop
    end
  end

  if not Rake::Task.task_defined?("db:schema:load")
    namespace :schema do
      task :load do
        # noop
      end
    end
  end

  if not Rake::Task.task_defined?("db:test:prepare")
    namespace :test do
      task :prepare => :environment do
        MongoMapper.connect('test')
        MongoMapper.database.collections.select {|c| c.name !~ /system/ }.each(&:drop)
        MongoMapper.connect(Rails.env)
      end
    end
  end
end

task 'test:prepare' => 'db:test:prepare'