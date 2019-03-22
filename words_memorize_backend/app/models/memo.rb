class Memo
  include Mongoid::Document
  include Mongoid::Timestamps

  MAX_RECENT_LENGTH = 20
  FREQ_RANK_WEIGHT_BASE = 25_000
  CALC_WEIGHT_LENGTH = 5         # for calc_weight

  field :user_id, type: String
  field :frequency, type: Float, default: 0

  field :total_count, type: Integer, default: 0     # total count of memo tests
  field :failed, type: Integer, default: 0          # total failed times of memo tests
  field :recent, type: Integer, default: 0          # the bitmap of the recent MAX_RECENT_LENGTH times of memo tests
  field :weight, type: Float

  belongs_to :word, index: true
  index({weight: -1}, background: true)
  index({user_id: 1, word_id: 1}, unique: true, background: true)

  default_scope ->{ desc(:weight) }

  before_save { self.weight = calc_weight }


  def add_test(succeed)
    self.total_count += 1
    self.failed += 1 unless succeed
    self.recent = (self.recent >> 1) | (succeed ? 1<<(MAX_RECENT_LENGTH-1) : 0)
    self
  end

  def recent_bits
    bits = recent.to_s(2)
    "0"*(MAX_RECENT_LENGTH-bits.size) + bits
  end

  def recent_succ_rate
    recent_succ_count.to_f/CALC_WEIGHT_LENGTH
  end

  def calc_weight
    recent_fail_rate = 1 - recent_succ_rate
    rank = Word.freq_rank(frequency).to_f
    freq_weight = [1 - rank/FREQ_RANK_WEIGHT_BASE, 0].max # map the rank 1~FREQ_RANK_WEIGHT_BASE to 1.0~0
    recent_fail_rate + freq_weight
  end

  private

  def recent_succ_count(length=CALC_WEIGHT_LENGTH)
    bits_count(recent >> (MAX_RECENT_LENGTH-length))
  end

  def bits_count(v)
    cnt = 0
    while v > 0
      cnt += 1
      v &= v-1
    end
    cnt
  end

end