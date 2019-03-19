require_relative '../../lib/word_freq_trie_by_db'
require_relative '../../lib/word_freq_trie_by_file'

namespace :export do

  # Word.frequent: 56992 words currently
  desc 'dump frequent words'
  task :dump_frequent_words, [:file_path, :limt] => :environment do |t, args|
    raise "usage: export:dump_frequent_words[file_path, limit]" unless args.file_path
    limit = args.limit || 100_000
    words = Word.frequent.limit(limit)
    puts "-----total words: #{words.count}"

    File.open(args.file_path, 'w') do |f|
      words.each do |w|
        f.puts "#{w.id}\t\t:#{w.freq_rank}"
      end
    end
    puts "-----saved: #{args.file_path}"
  end

  desc 'dump word_freq_trie_root'
  task :dump_trie_root, [:limt] => :environment do |t, args|
    limit = args.limit || 100_000
    words = Word.frequent.limit(limit)
    puts "-----total words: #{words.count}"

    file_path = WordFreqTrieByFile.dump_file(words: words)
    puts "-----saved: #{file_path}"
  end
end
