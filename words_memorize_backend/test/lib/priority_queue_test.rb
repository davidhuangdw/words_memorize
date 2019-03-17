require 'test_helper'
require_relative '../../lib/priority_queue'

class PriorityQueueTest < ActiveSupport::TestCase
  test 'is a min-heap' do
    arr = (1..100).to_a.shuffle
    que = PriorityQueue.new(arr[0...60])
    arr[60..-1].each{|v| que.push(v)}
    que_sort = que.size.times.map{ que.pop }

    assert que_sort == (1..100).to_a
  end

  test 'allow custom compare_by block' do
    arr = (1..100).to_a.shuffle
    que = PriorityQueue.new(arr[0...60]){|x| -x}
    arr[60..-1].each{|v| que.push(v)}
    que_sort = que.size.times.map{ que.pop }

    assert que_sort == 100.downto(1).to_a
  end

  test '#peek #size, #[]' do
    arr = (1..100).to_a.shuffle
    que = PriorityQueue.new(arr)

    assert que.peek == 1
    assert que.size == 100
    assert que[0] == 1
  end
end