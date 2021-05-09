<template>
  <v-row class="align-center justify-center">
    <div>
      <h1>Monitofen</h1>
      This application will allow you to
      <router-link to="measures">
        monitor all measures of your Okofen boiler
      </router-link>
    </div>
  </v-row>
</template>

<script>
export default {
  name: "HomePage"
}
</script>

<style scoped>
p {
  font-size: 2em;
  text-align: center;
}
</style>
