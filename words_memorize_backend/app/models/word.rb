class Word
  include Mongoid::Document
  field :name, type: String
  field :phonetic, type: String
  field :definition, type: String
  field :translation, type: String
  field :bnc, type: Float
  field :frq, type: Float
  field :frequency, type: Float # the higher the more frequent, range 0...(2*SCORE_CAP)
  # field :collins, type: Boolean
  # field :oxford, type: Boolean
  # field :tag, type: Array
  # field :exchange, type: String
  # field :detail, type: String

  field :_id, type: String, default: ->{ name }

  has_many :memos

  scope :frequent, ->{ where(:frequency.gt => 0) }
  default_scope ->{ desc(:frequency) }


  SCORE_CAP = 100_000

  class << self
    def build_from_ecdict_row(row)
      # refers to: https://github.com/skywind3000/ECDICT/blob/master/ecdict.mini.csv
      word, phonetic, definition, translation, pos, collins, oxford, tag, bnc, frq, exchange, detail, audio = row
      find_or_create_by(_id: word) do |w|
        w.assign_attributes(name: word,
                            phonetic: phonetic,
                            definition: definition,
                            translation: translation,
                            bnc: bnc.to_f,
                            frq: frq.to_f,
                            frequency: calc_frequency(bnc, frq))
      end
    end

    def reset_frequency
      # don't worry about the size, mongoid uses the cursor with a batch_size
      each{|w| w.update(frequency: w.calc_frequency) }
    end

    def calc_frequency(bnc, frq)
      # about frq/bnc: 1 means the most frequent, the higher the less frequent(range from 1 to SCORE_CAP), however 0 means too rare
      bnc = bnc.to_f
      frq = frq.to_f
      (frq.zero? ? 0 : SCORE_CAP - frq) + (bnc.zero? ? 0 : SCORE_CAP - bnc)
    end

    def freq_rank(frequency)
      SCORE_CAP - frequency/2.0   # result: 1...(SCORE_CAP)
    end
  end

  def calc_frequency
    self.class.calc_frequency(bnc, frq)
  end

  def freq_rank
    self.class.freq_rank(frequency)
  end
end
