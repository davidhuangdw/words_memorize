<template>
  <v-app id="app">
    <v-toolbar class="nav">
      <v-toolbar-side-icon></v-toolbar-side-icon>
      <v-toolbar-items class="hidden-sm-and-down">
        <v-btn flat @click="linkTo('/')"> Dictionary </v-btn>
        <v-btn flat @click="linkTo('memo')"> Memorize </v-btn>
      </v-toolbar-items>
    </v-toolbar>
    <router-view />
  </v-app>
</template>

<script>
export default {
  name: "app",
  methods: {
    linkTo(path) {
      this.$router.push(path);
    }
  }
};
</script>

<style lang="scss">
#app {
  font-family: "Avenir", Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
}
#nav {
  padding: 30px;
  a {
    font-weight: bold;
    color: #2c3e50;
    &.router-link-exact-active {
      color: #42b983;
    }
  }
}
</style>
