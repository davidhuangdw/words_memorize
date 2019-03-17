class WordFreqTrie
  TOP_K = 30

  class Node
    attr_accessor :nxt, :complete, :frequency
    attr_accessor :top_k_least, :max    # computed attrs

    def initialize
      self.complete = false
      self.nxt = {}
      self.frequency = 0
    end

    def search_most_frequents(result: [], path: [], least_freq: top_k_least)
      if max >= least_freq
        result.append([path.join, Word.freq_rank(frequency)]) if complete and frequency >= least_freq
        nxt.each do |ch, child_node|
          path.append(ch)
          child_node.search_most_frequents(result: result, path: path, least_freq: least_freq)
          path.pop
        end
      end
      result
    end
  end

  attr_reader :root

  def initialize(root)
    @root = root
  end

  def top_k(prefix)
    path = prefix.each_char.to_a
    node = root
    path.each do |ch|
      node = node.nxt[ch]
      break unless node
    end

    return {} unless node
    node.search_most_frequents(path: path)
        .sort_by{|x| x[1]}.to_h
  end
end
