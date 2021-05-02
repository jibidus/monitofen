<template>
  <v-alert
    type="error"
    role="aria-errormessage"
  >
    <slot />
  </v-alert>
</template>
<script>
export default {
  name: 'Error'
}
</script>
