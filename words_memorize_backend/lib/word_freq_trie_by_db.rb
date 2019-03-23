require_relative 'word_freq_trie'

class WordFreqTrieByDB < WordFreqTrie
  def initialize(words)
    @root = Node.new
    build_freq_trie(words)
    setup_node(root)
  end

  def build_freq_trie(words)
    words.each do |word|
      node = root
      word.id.each_char do |ch|
        node.nxt[ch] = Node.new unless node.nxt.include?(ch)
        node = node.nxt[ch]
      end
      node.complete = true
      node.frequency = word.frequency
    end
  end

  # setup :top_k_least, :max
  def setup_node(node)
    most, tmp = [], []
    most[0] = node.frequency if node.complete

    node.nxt.each do |ch, child_node|
      child_most = setup_node(child_node)
      merge(most, child_most, tmp)
    end

    node.max = most[0]
    node.top_k_least = most[TOP_K_SIZE - 1] || 0
    most
  end

  # merge desc_sorted a and b, and in-place a
  def merge(a, b, tmp, limit: TOP_K_SIZE)
    a.each_with_index{|v, i| tmp[i] = v}
    i = j = k = 0
    while k < limit && (i < tmp.size || j < b.size)
      if j >= b.size || (i < tmp.size && tmp[i] > b[j])   # descending
        a[k] = tmp[i]
        i += 1
      else
        a[k] = b[j]
        j += 1
      end
      k += 1
    end
  end
end