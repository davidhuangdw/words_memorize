<template>
  <v-container class="dictionary">
    <v-layout justify-center>
      <v-flex sm6>
        <v-text-field
          class="input-prefix"
          color="default"
          label="Search (strike 'enter' for exact match)"
          v-model="prefix"
          @input="autoRecommend"
          @keydown.enter="selectInput"
          @keydown.esc="clearInput"
        ></v-text-field>
      </v-flex>
    </v-layout>

    <v-layout>
      <v-flex sm3 class="recommend-list">
        <v-list>
          <v-list-tile
            v-for="word in recommended"
            :key="word.id"
            @click="select(word.id)"
          >
            <v-list-tile-content>{{ word.id }}</v-list-tile-content>
          </v-list-tile>
        </v-list>
      </v-flex>

      <v-flex sm9 class="px-4">
        <div v-if="selectedWord">
          <word-definition :word="selectedWord">
            <memo-state :word_id="selected"></memo-state>
          </word-definition>
        </div>
      </v-flex>
    </v-layout>
  </v-container>
</template>

<script>
/* eslint-disable no-console */
import axios from "axios";
import WordDefinition from "./WordDefinition.vue";
import MemoState from "./MemoState";
import { default_error_strategy } from "../utils/";

export default {
  name: "dictionary",
  components: {
    WordDefinition,
    MemoState
  },
  data: () => ({
    prefix: "",
    recommended: {},
    selected: ""
  }),
  computed: {
    wordIds() {
      return Object.keys(this.recommended);
    },
    selectedWord() {
      return this.recommended[this.selected];
    }
  },
  methods: {
    select(wordId) {
      this.selected = wordId;
    },
    clearInput() {
      this.prefix = "";
      this.autoRecommend();
    },
    selectInput() {
      if (this.recommended[this.prefix]) {
        this.selected = this.prefix;
      }
    },
    resetRecommended(recommended) {
      this.recommended = recommended;
      this.selected = this.wordIds[0];
    },
    autoRecommend() {
      const prefix = this.prefix;
      const allowed_errors = default_error_strategy(prefix.length);
      if (prefix.length < 2) {
        this.resetRecommended({});
        return;
      }
      axios
        .get("/words/recommend", {
          params: { prefix, allowed_errors, full_present: true }
        })
        .then(payload => {
          this.resetRecommended(payload.data);
        });
    }
  }
};
</script>

<style scoped>
.input-prefix {
  font-size: 2rem;
}

.recommend-list {
  height: 600px;
  overflow: scroll;
}
</style>
