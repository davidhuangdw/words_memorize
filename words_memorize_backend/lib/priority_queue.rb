class PriorityQueue
  attr_reader :que, :cmp_by
  delegate :size, :[], :to => :@que

  def initialize(arr=[], &blk)
    @cmp_by = blk || proc{|v| v}
    @que = arr.map.to_a
    heapify
  end

  def to_a
    @que.clone
  end

  def push(x)
    @que.push(x)
    sift_up(@que.size-1)
  end

  def pop
    return if @que.empty?
    top = @que[0]
    @que[0] = @que.pop
    sift_down(0)
    top
  end

  def peek
    @que[0]
  end

  def heapify
    ((que.size-1)<<1).downto(0).each{|i| sift_down(i)}
  end

  def sift_down(i)
    n = @que.size
    lc, rc = (i<<1)+1, (i<<1)+2
    while lc < n
      j = (rc < n ? [i, lc, rc] : [i, lc]).min_by{|k| @cmp_by[@que[k]]}
      break if j == i
      @que[i], @que[j] = @que[j], @que[i]
      i, lc, rc = j, (j<<1)+1, (j<<1)+2
    end
  end

  def sift_up(i)
    while i > 0
      par = (i-1)>>1
      break unless @cmp_by[@que[i]] < @cmp_by[@que[par]]
      @que[i], @que[par] = @que[par], @que[i]
      i = par
    end
  end
end