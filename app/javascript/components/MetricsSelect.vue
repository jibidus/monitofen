<template>
  <div aria-busy="loading">
    <Spinner v-if="loading" />
    <Error v-else-if="error">
      {{ error }}
    </Error>
    <v-combobox
      v-else
      id="metric"
      v-model="selectedMetric"
      :items="metrics"
      item-text="label"
      label="Metric"
      prepend-icon="fa-ruler-combined"
    />
  </div>
</template>

<script>
import axios from "axios";
import FetchData from "../mixins/FetchData";
import Spinner from "./Spinner";
import Error from "./Error";

export default {
  name: "MetricsSelect",
  components: {Error, Spinner},
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
  watch: {
    selectedMetric: function(metric) {
      this.$emit('input', metric);
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
  }
}
</script>

