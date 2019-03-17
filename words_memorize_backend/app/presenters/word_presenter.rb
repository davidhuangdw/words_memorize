require_relative '../../app/models/word'

class WordPresenter

  def self.from_array(words)
    {
        items: words.map{|w| WordPresenter.new(w)}
    }
  end

  attr_reader :instance
  def initialize(word, options={})
    @instance = word
  end

  def as_json(*)
    instance.instance_eval do
      {
          id: id,
          phonetic: phonetic,
          definition: definition,
          translation: translation,
          freq_rank: freq_rank,
      }
    end
  end
end