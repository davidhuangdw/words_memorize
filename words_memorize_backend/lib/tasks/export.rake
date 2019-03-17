require_relative '../../lib/word_freq_trie_by_db'
require_relative '../../lib/word_freq_trie_by_file'

namespace :export do

  # current: 56992 words(frequency > 0), dump file size 17MB
  desc 'dump word_freq_trie_root'
  task :dump_trie_root, [:limt] => :environment do |t, args|
    limit = args.limit || 100_000
    words = Word.where(:frequency.gt => 0).desc(:frequency).limit(limit)
    puts "-----total words: #{words.count}"

    file_path = WordFreqTrieByFile.dump_file(words: words)
    puts "-----saved: #{file_path}"
  end
end
