<template>
  <div>
    <p>Here are measures</p>
    <MetricsSelect v-model="metric" />
    <MeasuresChartWrapper
      v-if="metric"
      :metric="metric"
    />
  </div>
</template>

<script>
import MeasuresChartWrapper from "./components/MeasuresChartWrapper";
import MetricsSelect from "./components/MetricsSelect";

export default {
  name: "MeasuresPage",
  components: {MetricsSelect, MeasuresChartWrapper},
  data() {
    return {metric: null}
  },
}
</script>

<style scoped>

</style>
