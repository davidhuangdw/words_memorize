require_relative '../../app/models/word'
require_relative '../../app/models/memo'

class MemoPresenter

  def self.from_array(memos, options={})
    memos = memos.includes(:word) if options[:include_word]
    {
        items: memos.map{|w| MemoPresenter.new(w, options)}
    }
  end

  attr_reader :instance, :options
  def initialize(memo, options={})
    @instance = memo
    @options=options
  end

  def as_json(*)
    that = self
    instance.instance_eval do
      {
          id: id,
          word_id: word_id,
          # updated_at: updated_at,
          # user_id: user_id,
          weight: weight,
          recent_bits: recent_bits,
          total_count: total_count,
          word: that.options[:include_word] ? WordPresenter.new(word) : nil
      }
    end
  end
end