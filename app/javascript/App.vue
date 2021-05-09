<template>
  <v-app>
    <v-app-bar
      app
      dense
    >
      <v-toolbar-title>{{ $route.name }}</v-toolbar-title>
      <v-spacer />
      <vuetify-css-breakpoint v-if="environment === 'development'" />
    </v-app-bar>
    <v-main>
      <v-container fluid>
        <router-view />
      </v-container>
    </v-main>
  </v-app>
</template>

<script>
import VuetifyCssBreakpoint from "./VuetifyCssBreakpoint";
export default {
  name: "App",
  components: {VuetifyCssBreakpoint},
  computed: {
    environment() {
      return document.getElementsByTagName("body")[0].getAttribute("data-env");
    }
  }
}
</script>

<style scoped>
</style>
