<template>
  <v-app>
    <v-main>
      <div
        v-if="environment === 'development'"
        class="float-right pa-2"
      >
        {{ $vuetify.breakpoint.name }}
      </div>
      <v-container>
        <router-view />
      </v-container>
    </v-main>
  </v-app>
</template>

<script>
export default {
  name: "App",
  computed: {
    environment() {
      return document.getElementsByTagName("body")[0].getAttribute("data-env");
    }
  }
}
</script>

<style scoped>
</style>
