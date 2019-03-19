require_relative '../../app/presenters/word_presenter'

class WordsController < ApplicationController

  def index
    require_params!(:ids)

    word_ids = params[:ids].split(',')
    words = Word.in(id: word_ids)
    render json: WordPresenter.from_array(words)
  end

  def show
    word = Word.find(params[:id])
    render json: WordPresenter.new(word)
  end

  # optional params: :full_present, :error_ratio, :allowed_errors
  def recommend
    require_params!(:prefix)
    prefix = params[:prefix]
    allowed_errors = (params[:allowed_errors] || (params[:error_ratio] && error_ratio_params*params[:prefix].size) || 0).to_i

    top_k = FREQ_TRIE_SINGLETON.top_k(prefix, allowed_errors)

    if params[:full_present].present?
      word_ids = top_k.keys.push(prefix)
      top_k = Word.in(id: word_ids).map{|w| [w.id, WordPresenter.new(w)]}.to_h
    elsif !top_k.include?(prefix)             # in case that the prefix is a rare word
      word = Word.only(:id, :frequency).find(prefix) rescue nil
      top_k[word.id] = word.freq_rank if word
    end

    render json: top_k
  end

  private

  def error_ratio_params
    if(ratio = params[:error_ratio])
      ratio = ratio.to_f
      ratio > 1 ? 1/ratio : ratio
    end
  end

end
