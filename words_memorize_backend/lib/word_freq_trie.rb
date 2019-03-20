require 'set'
require_relative '../lib/priority_queue'

class WordFreqTrie
  TOP_K = 50

  class Node
    attr_accessor :nxt, :complete, :frequency
    attr_accessor :top_k_least, :max    # computed attrs

    def initialize
      self.complete = false
      self.nxt = {}
      self.frequency = 0
    end

    def search_most_frequents(result_que:, path: [], context: {least_freq: top_k_least})
      if max >= context[:least_freq]
        if complete and frequency >= context[:least_freq]
          result_que.push([path.join, frequency])
          if result_que.size > TOP_K
            result_que.pop
            context[:least_freq] = result_que.peek[1]   # wrap :least_freq inside 'context' to update it
          end
        end

        nxt.each do |ch, child_node|
          path.push(ch)
          child_node.search_most_frequents(result_que: result_que, path: path, context: context)
          path.pop
        end
      end
      result_que
    end

    def search_reachable(i, prefix, allowed_errors = 0, path: [], result: {}, visited: Set.new)
      return result if visited.include?([self, i])
      visited.add([self, i])    # todo: eliminate redundancy further

      if prefix.size - i <= allowed_errors
        result[self] = path.clone unless result.include?(self)
        return result
      end
      opt = {path:path, result: result, visited: visited}

      path.push(prefix[i])
      nxt[prefix[i]] && nxt[prefix[i]].search_reachable(i+1, prefix, allowed_errors, opt)
      path.pop

      if allowed_errors > 0
        # delete 1 char
        search_reachable(i+1, prefix, allowed_errors-1, opt)

        nxt.each do |ch, child_node|
          path.push(ch)
          # insert 1 char
          child_node.search_reachable(i, prefix, allowed_errors-1, opt)
          # replace 1 char
          child_node.search_reachable(i+1, prefix, allowed_errors-1, opt)
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

  def top_k(prefix, allowed_errors=0)
    node_path_pairs = root.search_reachable(0, prefix, allowed_errors.to_i)
    puts "----reachable nodes: #{node_path_pairs.size}"
    # p node_path_pairs.values.map(&:join).sort

    que = PriorityQueue.new{|word_freq_pair| word_freq_pair[1]}
    node_path_pairs.each{|node, path| node.search_most_frequents(result_que: que, path: path) }
    que.to_a.sort_by{|word_freq_pair| Word.freq_rank(word_freq_pair[1])}.to_h
  end
end
