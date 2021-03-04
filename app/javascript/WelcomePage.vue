<template>
  <div>
    <p>Welcome to Monitofen!</p>
    <p>
      This application will allow you to <router-link to="measures">
        monitor all measures of your Okofen boiler
      </router-link>.
    </p>
  </div>
</template>

<script>
export default {
  name: "WelcomePage"
}
</script>

<style scoped>
p {
  font-size: 2em;
  text-align: center;
}
</style>
