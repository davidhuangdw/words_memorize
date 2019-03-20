<template>
  <div class="home">
    <dictionary></dictionary>
  </div>
</template>

<script>
// @ is an alias to /src
import Dictionary from "@/components/Dictionary.vue";

export default {
  name: "home",
  components: {
    Dictionary
  }
};
</script>
