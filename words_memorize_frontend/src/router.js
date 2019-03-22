import Vue from "vue";
import Router from "vue-router";
import Dictionary from "./components/Dictionary";
import Memorize from "./components/Memorize";

Vue.use(Router);

export default new Router({
  mode: "history",
  base: process.env.BASE_URL,
  routes: [
    {
      path: "/",
      name: "dictionary",
      component: Dictionary
    },
    {
      path: "/memo",
      name: "memo",
      // route level code-splitting
      // this generates a separate chunk (about.[hash].js) for this route
      // which is lazy-loaded when the route is visited.
      component: Memorize
    }
  ]
});
