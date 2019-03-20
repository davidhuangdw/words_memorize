<template>
  <v-container>
    <v-layout justify-center>
      <v-flex sm6>
        <v-text-field
          class="input-prefix"
          label="Search"
          v-model="prefix"
          @keyup="autoRecommend"
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

      <v-flex sm9 class="word-definition pa-3">
        <div v-if="selectedWord">
          <h1>{{ selectedWord.id }} [{{ selectedWord.phonetic }}]</h1>

          <v-divider></v-divider>
          <p v-html="splitLines(selectedWord.definition)" />

          <v-divider></v-divider>
          <p v-html="splitLines(selectedWord.translation)" />

          <v-divider></v-divider>
          {{ selectedWord.freq_rank }}
        </div>
      </v-flex>
    </v-layout>
  </v-container>
</template>

<script>
/* eslint-disable no-console */
import axios from "axios";

export default {
  name: "dictionary",
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
    resetRecommended(recommended) {
      this.recommended = recommended;
      this.selected = this.wordIds[0];
    },
    autoRecommend() {
      const prefix = this.prefix;
      if (prefix.length < 2) {
        this.resetRecommended({});
        return;
      }
      axios
        .get("/words/recommend", {
          params: { prefix: this.prefix, full_present: true, allowed_errors: 1 }
        })
        .then(payload => {
          this.resetRecommended(payload.data);
        });
    },
    splitLines(str) {
      return str
        .split("\\n")
        .map(line => `<p>${line}</p>`)
        .join("");
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

.word-definition {
  text-align: left;
}
</style>
