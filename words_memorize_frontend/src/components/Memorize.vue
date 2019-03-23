<template>
  <v-container class="memorize">
    <v-layout class="config">
      <v-flex sm3>
        <v-slider
          thumb-label
          label="succ rate <="
          v-model="recent_succ_rate_cap"
        ></v-slider>
        <v-switch
          v-model="always_need_answer"
          label="need answer selected"
        ></v-switch>
      </v-flex>
      <v-flex sm6 align-self-center>
        <v-btn @click="random_pick" color="primary">Weighted Random Test</v-btn>
      </v-flex>
    </v-layout>

    <v-layout>
      <v-flex sm3 class="memo-list">
        <v-list>
          <v-list-tile
            v-for="memo in filteredMemos"
            :key="memo.word_id"
            @click="select(memo.word_id)"
          >
            <v-list-tile-content>{{ memo.word_id }}</v-list-tile-content>
          </v-list-tile>
        </v-list>
      </v-flex>

      <v-flex sm9 class="px-4">
        <div v-if="selectedWord">
          <word-definition :word="selectedWord" :hide_def="wait_for_answer">
            <div v-show="wait_for_answer">
              <v-btn
                class="mx-0"
                color="white--text red darken-1"
                :disabled="requesting"
                @click="answer(false)"
                >Forgot</v-btn
              >
              <v-btn
                color="white--text green darken-1"
                :diabled="requesting"
                @click="answer(true)"
                >Known</v-btn
              >
            </div>
            <div v-show="answered">
              <v-btn
                class="mx-0"
                color="white--text red darken-1"
                :disabled="requesting || confirmed"
                @click="addTest(false)"
                >Wrong</v-btn
              >
              <v-btn
                color="white--text green darken-1"
                :disabled="requesting || confirmed"
                @click="addTest(true)"
                >Correct</v-btn
              >
            </div>

            <memo-state
              v-show="!wait_for_answer"
              :word_id="selected"
              :hide_actions="answered"
            ></memo-state>
          </word-definition>
        </div>
      </v-flex>
    </v-layout>
  </v-container>
</template>

<script>
import { mapState, mapGetters, mapActions } from "vuex";
import WordDefinition from "./WordDefinition.vue";
import MemoState from "./MemoState";
import { str_bits_ratio, random_pick_acc_arr } from "../utils/";
import {
  RECENT_SUCC_RATE_FILTER_LEN,
  INIT_SUCC_RATE
} from "../utils/constants";

export default {
  name: "Memorize",
  components: {
    WordDefinition,
    MemoState
  },
  data: () => ({
    requesting: false,
    selected: "",
    recent_succ_rate_cap: INIT_SUCC_RATE,
    always_need_answer: false,
    need_answer: true,
    answered: false,
    confirmed: false
  }),
  computed: {
    ...mapState(["memos"]),
    ...mapGetters(["getFilteredMemos"]),
    selectedMemo() {
      return this.memos[this.selected];
    },
    selectedWord() {
      return this.selectedMemo && this.selectedMemo.word;
    },
    filteredMemos() {
      const filter_by = ({ recent_bits }) =>
        str_bits_ratio(recent_bits, RECENT_SUCC_RATE_FILTER_LEN) <=
        this.recent_succ_rate_cap / 100.0;
      const sort_by = ({ weight }) => -weight;
      return this.getFilteredMemos({ filter_by, sort_by });
    },
    acculatedWeights() {
      const sums = [0];
      let pre = 0;
      for (let memo of this.filteredMemos) {
        pre += memo.weight;
        sums.push(pre);
      }
      return sums;
    },
    wait_for_answer() {
      return (this.always_need_answer || this.need_answer) && !this.answered;
    }
  },
  methods: {
    ...mapActions(["addMemoTest"]),
    reset(need_answer) {
      this.need_answer = need_answer;
      this.answered = false;
      this.confirmed = false;
      this.selected = "";
    },
    select(word_id) {
      this.reset(false);
      this.selected = word_id;
    },
    random_pick() {
      // pick a memo with the probability proportional to its weight among filteredMemos
      if (this.acculatedWeights.length < 1) return;
      const i = random_pick_acc_arr(this.acculatedWeights);
      this.reset(true);
      this.selected = this.filteredMemos[i].word_id;
    },
    addTest(succeed) {
      this.requesting = true;
      const done = () => {
        this.requesting = false;
        this.confirmed = true;
      };
      this.addMemoTest({ word_id: this.selected, succeed }).then(done, done);
    },
    answer(known) {
      this.answered = true;
      if (!known) this.addTest(false);
    }
  }
};
</script>

<style scoped>
.memo-list {
  height: 600px;
  overflow: scroll;
}
</style>
