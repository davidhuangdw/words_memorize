<template>
  <div class="memo-state">
    <v-btn
      class="mx-0"
      color="white--text red darken-1"
      :disabled="posting"
      @click="addTest(false)"
      >Forgot</v-btn
    >
    <v-btn
      color="white--text green darken-1"
      :diabled="posting"
      @click="addTest(true)"
      >Remember</v-btn
    >

    <span v-for="(succeed, i) in recent_tests" :key="i">
      <v-icon v-if="succeed" class="light-green--text test-icon">
        mdi-emoticon-happy-outline
      </v-icon>
      <v-icon v-else class="test-icon"> mdi-emoticon-dead-outline </v-icon>
    </span>

    {{ memo && memo.weight }}
  </div>
</template>

<script>
import { mapGetters, mapActions } from "vuex";
import axios from "axios";

export default {
  name: "WordDefinition",
  data: () => ({ posting: false }),
  props: {
    word_id: String
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
    ...mapActions(["insertMemo"]),
    addTest(succeed) {
      this.posting = true;
      axios
        .post("memos/add_test", { word_id: this.word_id, succeed })
        .then(payload => {
          this.insertMemo(payload.data);
          this.posting = false;
        })
        .catch(() => (this.posting = false));
    }
  }
};
</script>

<style scoped>
.test-icon {
  font-size: 1.3rem;
}
</style>
