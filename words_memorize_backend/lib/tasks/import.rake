require 'csv'

namespace :import do

  # refers to:  https://github.com/skywind3000/ECDICT/blob/master/ecdict.csv
  # totally 770k words
  desc 'read ecdict CSV file'
  task :from_ecdict_csv, [:file_name] => :environment do |t, args|
    puts "---- reading #{args.file_name}"
    progress = 0

    CSV.foreach(args.file_name, headers: true) do |row|
      progress += 1
      if (progress % 1000).zero?
        puts "progress: #{progress}"
        sleep 1
        puts 'continue...'
      end
      Word.build_from_ecdict_row(row.fields)
    end
  end
end