<template>
  <div class="word-definition">
    <div class="display-1">
      {{ word.id }}
      <span class="grey--text text--lighten-1"> [{{ word.phonetic }}] </span>
    </div>

    <memo-state :word_id="word.id"></memo-state>

    <br/>
    <div class="en-definition" v-html="splitLines(word.definition)" />

    <v-divider></v-divider>
    <div v-html="splitLines(word.translation)" />

    <v-divider></v-divider>
    Freq Rank: {{ word.freq_rank }}
  </div>
</template>

<script>
import MemoState from "./MemoState";
import { splitLines } from "../utils";

export default {
  name: "WordDefinition",
  components: {
    MemoState
  },
  props: {
    word: Object,
  },
  methods: {
    splitLines
  }
};
</script>

<style scoped>
* {
  text-align: left;
}

.en-definition {
  font-size: 1.2rem;
}
</style>
