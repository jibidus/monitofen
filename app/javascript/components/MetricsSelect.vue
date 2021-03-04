<template>
  <div :aria-busy="loading">
    <p
      v-if="loading"
      role="progressbar"
    >
      Loading…
    </p>
    <p
      v-else-if="error"
      role="aria-errormessage"
    >
      {{ error }}
    </p>
    <form v-else>
      <label for="metric">Metric</label>
      <select
        id="metric"
        v-model="selectedMetric"
        @change="onChange(selectedMetric)"
      >
        <option
          v-for="metric in metrics"
          :key="metric.id"
          :value="metric"
        >
          {{ metric.label }}
        </option>
      </select>
    </form>
  </div>
</template>

<script>
import axios from "axios";
import FetchData from "../mixins/FetchData";

export default {
  name: "MetricsSelect",
  mixins: [FetchData],
  props: {
    value: {type: Object, default: null}
  },
  data() {
    return {
      metrics: null,
      selectedMetric: null,
    }
  },
  methods: {
    async fetchData() {
      const response = await axios.get('/metrics');
      if (response.status !== 200) {
        this.error = `cannot fetch metrics: ${response.statusText} (http code = ${response.status})`;
        return;
      }
      this.metrics = response.data;
    },
    onChange(metric) {
      this.$emit('input', metric);
    }
  }
}
</script>

<style scoped>

</style>
