<template>
  <v-app>
    <v-main>
      <v-container
        class="ma-6"
        fluid
        fill-height
      >
        <v-row class="align-center justify-center">
          <div>
            <h1>Monitofen</h1>
            This application will allow you to
            <router-link to="measures">
              monitor all measures of your Okofen boiler
            </router-link>
          </div>
        </v-row>
      </v-container>
    </v-main>
  </v-app>
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
