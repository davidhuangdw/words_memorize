class Word
  include Mongoid::Document
  field :name, type: String
  field :phonetic, type: String
  field :definition, type: String
  field :translation, type: String
  field :bnc, type: Float
  field :frq, type: Float

  # field :collins, type: Boolean
  # field :oxford, type: Boolean
  # field :tag, type: Array
  # field :exchange, type: String
  # field :detail, type: String

  field :_id, type: String, default: ->{ name }

  class << self
    def build_from_ecdict_row(row)
      word, phonetic, definition, translation, pos, collins, oxford, tag, bnc, frq, exchange, detail, audio = row
      find_or_create_by(_id: word) do |w|
        w.set(name: word,
              phonetic: phonetic,
              definition: definition,
              translation: translation,
              bnc: bnc.to_f,
              frq: frq.to_f,
              )
      end
    end
  end
end