require_relative 'word_freq_trie'
require_relative 'word_freq_trie_by_db'

# the purpose is to save the query from mongodb
class WordFreqTrieByFile < WordFreqTrie
  DEFAULT_DUMP_FILE_PATH = 'tmp/trie_root.json'

  def initialize(trie_node_file_path = DEFAULT_DUMP_FILE_PATH)
    @root = Oj.load_file(trie_node_file_path, {})
  end

  def self.dump_file(file_path: DEFAULT_DUMP_FILE_PATH, words:)
    trie = WordFreqTrieByDB.new(words)
    Oj.to_file(file_path, trie.root, {})
    file_path
  end
end