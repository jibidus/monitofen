<template>
  <div>
    <v-row>
      <v-col>
        <h1 data-type="title">
          <v-icon>fa-analytics</v-icon>
          Measurements explorer
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
        <MeasurementsChartWrapper
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
import MeasurementsChartWrapper from "./components/MeasurementsChartWrapper";
import MetricsSelect from "./components/MetricsSelect";
import TimePeriodSelector from "./components/TimePeriodSelector";

export default {
  name: "MeasurementsPage",
  components: {TimePeriodSelector, MetricsSelect, MeasurementsChartWrapper: MeasurementsChartWrapper},
  data() {
    return {metric: null, timePeriod: null}
  },
}
</script>

<style scoped>

</style>
