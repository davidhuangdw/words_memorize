<template>
  <div class="word-definition">
    <div class="display-1">
      {{ word.id }}
      <span class="grey--text text--lighten-1"> [{{ word.phonetic }}] </span>
    </div>

    <slot></slot>

    <br />
    <div v-show="!hide_def">
      <div class="en-definition" v-html="splitLines(word.definition)" />

      <v-divider></v-divider>
      <div v-html="splitLines(word.translation)" />

      <v-divider></v-divider>
      Freq Rank: {{ word.freq_rank }}
    </div>
  </div>
</template>

<script>
import { splitLines } from "../utils";

export default {
  name: "WordDefinition",
  props: {
    word: Object,
    hide_def: Boolean
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
