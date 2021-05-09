<template>
  <div>
    <v-row>
      <v-col>
        <h1>
          <v-icon>fa-analytics</v-icon>
          Measures explorer
        </h1>
      </v-col>
    </v-row>
    <v-row>
      <v-col
        xs="12"
        sm="6"
        md="4"
        lg="3"
      >
        <MetricsSelect v-model="metric" />
      </v-col>
    </v-row>
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
  }
}
</script>

<style scoped>

</style>
