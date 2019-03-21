<template>
  <v-container>
    <v-layout justify-center>
      <v-flex sm6>
        <v-text-field
          class="input-prefix"
          label="Search"
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
          <word-definition :word="selectedWord"></word-definition>
        </div>
      </v-flex>
    </v-layout>
  </v-container>
</template>

<script>
/* eslint-disable no-console */
import WordDefinition from "@/components/WordDefinition.vue";
import axios from "axios";

export default {
  name: "dictionary",
  components: {
    WordDefinition,
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
