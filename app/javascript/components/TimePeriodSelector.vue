<template>
  <v-menu
    v-model="menu"
    :close-on-content-click="false"
    :nudge-right="40"
    transition="scale-transition"
    offset-y
    min-width="auto"
  >
    <template #activator="{ on, attrs }">
      <v-text-field
        v-model="date"
        label="Day"
        prepend-icon="fa-calendar"
        readonly
        v-bind="attrs"
        v-on="on"
      />
    </template>
    <v-date-picker
      v-model="date"
      :max="yesterday"
      :show-current="today"
      @input="menu = false"
    />
  </v-menu>
</template>

<script>
import moment from "moment-timezone";

const DATE_FORMAT = "YYYY-MM-DD";

export default {
  name: "TimePeriodSelector",
  data() {
    return {date: moment().subtract(1, 'days').format(DATE_FORMAT), menu: false};
  },
  computed: {
    from() {
      return moment(this.date, DATE_FORMAT).startOf('day');
    },
    to() {
      return moment(this.date, DATE_FORMAT).endOf('day');
    },
    yesterday() {
      return moment().subtract(1, 'days').format(DATE_FORMAT);
    },
    today() {
      return moment().format(DATE_FORMAT);
    },
  },
  watch: {
    date() {
      this.$emit('input', {from: this.from, to: this.to});
    }
  },
  mounted() {
    this.$emit('input', {from: this.from, to: this.to});
  }
}
</script>

<style scoped>

</style>
