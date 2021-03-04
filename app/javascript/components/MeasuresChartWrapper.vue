<template>
  <div>
    <div
      v-if="loading"
      role="progressbar"
    >
      loading…
    </div>
    <div
      v-else-if="error"
      role="aria-errormessage"
    >
      {{ error }}
    </div>
    <div
      v-else-if="measures.length === 0"
      role="placeholder"
    >
      No measure
    </div>
    <div v-else>
      {{ measures.length }} measure(s) found
      <MeasuresChart :measures="measures" />
    </div>
  </div>
</template>

<script>
import FetchData from "../mixins/FetchData";
import axios from "axios";
import MeasuresChart from "./MeasuresChart";

export default {
  name: "MeasuresChartWrapper",
  components: {MeasuresChart},
  mixins: [FetchData],
  props: {
    metric: {type: Object, required: true}
  },
  data() {
    return {      measures: null}
  },
  watch: {
    metric() {
      this.loadData();
    },
  },
  methods: {
    async fetchData() {
      const response = await axios.get(`/metrics/${this.metric.id}/measures`);
      if (response.status !== 200) {
        this.error = `cannot fetch measures: ${response.statusText} (http code = ${response.status})`;
        return;
      }
      this.measures = response.data;
    },
  }
}
</script>

<style scoped>

</style>
