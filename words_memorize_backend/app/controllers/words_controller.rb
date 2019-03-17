require_relative '../../app/presenters/word_presenter'

class WordsController < ApplicationController

  def index
    require_params!(:ids)

    words = Word.in(id: params[:ids].split(','))
    render json: WordPresenter.from_array(words)
  end

  def show
    word = Word.find(params[:id])
    render json: WordPresenter.new(word)
  end

  def recommend
    require_params!(:prefix)
    prefix = params[:prefix]

    top_k = FREQ_TRIE_SINGLETON.top_k(prefix)
    unless top_k.include?(prefix)
      word = Word.only(:id, :frequency).find(prefix) rescue nil
      top_k[prefix] = word.freq_rank if word
    end

    render json: top_k
  end

end
