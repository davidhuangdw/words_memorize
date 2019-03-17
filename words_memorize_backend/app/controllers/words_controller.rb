require_relative '../../app/presenters/word_presenter'

class WordsController < ApplicationController

  def index
    require_params!(:ids)

    word_ids = params[:ids].split(',')
    words = Word.in(id: word_ids).desc(:frequency)
    render json: WordPresenter.from_array(words)
  end

  def show
    word = Word.find(params[:id])
    render json: WordPresenter.new(word)
  end

  # support params: :allowed_errors, :full_present
  def recommend
    require_params!(:prefix)
    prefix = params[:prefix]
    allowed_errors = params[:allowed_errors] || 0
    full_present = params[:full_present].present?

    top_k = FREQ_TRIE_SINGLETON.top_k(prefix, allowed_errors)
    unless top_k.include?(prefix)
      word = Word.only(:id, :frequency).find(prefix) rescue nil
      top_k[word.id] = word.freq_rank if word
    end

    if full_present
      word_ids = top_k.keys
      top_k = Word.in(id: word_ids).desc(:frequency)
                  .map{|w| [w.id, WordPresenter.new(w)]}.to_h
    end

    render json: top_k
  end

end
