require_relative '../../lib/word_freq_trie_by_file'

FREQ_TRIE_SINGLETON = WordFreqTrieByDB.new(Word.frequent)