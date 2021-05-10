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
      <v-col>
        <MetricsSelect v-model="metric" />
      </v-col>
      <v-col>
        <time-period-selector
          @input="timePeriod = $event"
        />
      </v-col>
    </v-row>
    <v-row>
      <v-col>
        <MeasuresChartWrapper
          v-if="metric"
          :metric="metric"
          :from="timePeriod.from"
          :to="timePeriod.to"
        />
      </v-col>
    </v-row>
  </div>
</template>

<script>
import MeasuresChartWrapper from "./components/MeasuresChartWrapper";
import MetricsSelect from "./components/MetricsSelect";
import TimePeriodSelector from "./components/TimePeriodSelector";

export default {
  name: "MeasuresPage",
  components: {TimePeriodSelector, MetricsSelect, MeasuresChartWrapper},
  data() {
    return {metric: null, timePeriod: null}
  },
}
</script>

<style scoped>

</style>
