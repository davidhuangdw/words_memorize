<template>
  <div class="memo-state">
    <div v-show="!hide_actions">
      <v-btn
          class="mx-0"
          color="white--text red darken-1"
          :disabled="requesting"
          @click="addTest(false)"
      >Forgot</v-btn
      >
      <v-btn
          color="white--text green darken-1"
          :diabled="requesting"
          @click="addTest(true)"
      >Known</v-btn
      >
    </div>

    <div>
      <span v-for="(succeed, i) in recent_tests" :key="i">
        <v-icon v-if="succeed" class="light-green--text test-icon">
          mdi-emoticon-happy-outline
        </v-icon>
        <v-icon v-else class="test-icon"> mdi-emoticon-dead-outline </v-icon>
      </span>

      {{ memo && memo.weight }}
    </div>
  </div>
</template>

<script>
import { mapGetters, mapActions } from "vuex";

export default {
  name: "WordDefinition",
  data: () => ({ requesting: false }),
  props: {
    word_id: String,
    hide_actions: Boolean
  },
  computed: {
    ...mapGetters(["getMemo", "getRecentTests"]),
    memo() {
      return this.getMemo(this.word_id);
    },
    recent_tests() {
      return this.getRecentTests(this.word_id);
    }
  },
  methods: {
    ...mapActions(["addMemoTest"]),
    addTest(succeed) {
      this.requesting = true;
      const done = () => (this.requesting = false);
      this.addMemoTest({ word_id: this.word_id, succeed }).then(done, done);
    }
  }
};
</script>

<style scoped>
.test-icon {
  font-size: 1.3rem;
}
</style>
