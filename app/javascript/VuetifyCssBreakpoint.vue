<template>
  <v-tooltip left>
    <template #activator="{ on, attrs }">
      <span
        v-bind="attrs"
        v-on="on"
      >
        <v-icon>fa-border-style</v-icon>
        {{ $vuetify.breakpoint.name }}
      </span>
    </template>
    <span>CSS breakpoint for Vuetify</span>
  </v-tooltip>
</template>

<script>
export default {
  name: "VuetifyCssBreakpoint"
}
</script>

<style scoped>

</style>
