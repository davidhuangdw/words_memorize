/* eslint-disable no-console */
import Vue from "vue";
import Vuex from "vuex";
import axios from "axios";
import _ from "lodash";
import { LOADING, LOADED, FAILED, MAX_RECENT_RECORD_LEN } from "./utils/constants";

Vue.use(Vuex);

const state = {
  status: null,
  memos: {}
};

const getters = {
  getMemo: state => word_id => {
    return state.memos[word_id];
  },
  getRecentTests: state => word_id => {
    const memo = state.memos[word_id];
    if (!memo) return [];

    const { recent_bits, total_count } = memo;
    const len = Math.min(
      MAX_RECENT_RECORD_LEN,
      total_count,
      recent_bits.length
    );
    return _.map(recent_bits.slice(0, len), ch => ch === "1");
  }
};

const mutations = {
  UPDATE_STATUS: (state, status) => {
    state.status = status;
  },
  IMPORT_MEMOS: (state, memos) => {
    memos.forEach(memo => mutations.INSERT_MEMO(state, memo));
  },
  INSERT_MEMO: (state, memo) => {
    Vue.set(state.memos, memo.word_id, memo);
  }
};

const actions = {
  fetchMemos: ({ commit, state }) => {
    if (state.status) return;
    commit("UPDATE_STATUS", LOADING);
    axios.get("memos", { params: { user_id: null, include_word: true } }).then(
      payload => {
        commit("IMPORT_MEMOS", payload.data.items);
        commit("UPDATE_STATUS", LOADED);
      },
      reason => {
        console.log(JSON.stringify(reason));
        commit("UPDATE_STATUS", FAILED);
      }
    );
  },
  insertMemo: ({ commit }, memo) => {
    commit("INSERT_MEMO", memo);
  }
};

const store = new Vuex.Store({
  state,
  getters,
  mutations,
  actions
});
store.dispatch("fetchMemos");

export default store;
