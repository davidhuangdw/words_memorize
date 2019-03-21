require_relative '../../app/presenters/memo_presenter'

class MemosController < ApplicationController
  DEFAULT_LIMIT = 500

  def index
    limit = (params[:limit] || DEFAULT_LIMIT).to_i
    memos = Memo.where(user_id: params[:user_id]).limit(DEFAULT_LIMIT)
    memos = memos.in(word_id: params[:word_ids].split(',')) if params[:word_ids]
    render json: MemoPresenter.from_array(memos, presenter_option)
  end

  def show
    require_params!(:id)

    word = Memo.find(params[:id])
    render json: MemoPresenter.new(word, presenter_option)
  end

  def destroy
    require_params!(:id)
    Memo.find(params[:id]).destroy
  end

  def add_test
    require_params!(:word_id, :succeed)
    memo = Memo.find_or_create_by(user_id: params[:user_id], word_id: params[:word_id]) do |m|
      m.assign_attributes(frequency: m.word.frequency)
    end
    memo.add_test(params[:succeed])
    memo.save

    render json: MemoPresenter.new(memo, presenter_option)
  end

  private

  def presenter_option
    { include_word: params[:include_word] }
  end

end
