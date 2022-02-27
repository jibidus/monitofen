<template>
  <div>
    <Spinner v-if="loading" />
    <Error v-else-if="error">
      {{ error }}
    </Error>
    <div
      v-else-if="measurements.length === 0"
      role="placeholder"
    >
      No measurement
    </div>
    <div v-else>
      {{ measurements.length }} measurement(s) found
      <MeasurementsChart
        :measurements="measurements"
        :metric-label="metric.label"
      />
    </div>
  </div>
</template>

<script>
import FetchData from "../mixins/FetchData";
import moment from 'moment-timezone';
import axios from "axios";
import MeasurementsChart from "./MeasurementsChart";
import Spinner from "./Spinner";
import Error from "./Error";
import {API_DATE_FORMAT} from '../constants';

export default {
  name: "MeasurementsChartWrapper",
  components: {MeasurementsChart, Spinner, Error},
  mixins: [FetchData],
  props: {
    metric: {type: Object, required: true},
    from: {type: Object, required: false, default: null},
    to: {type: Object, required: false, default: null}
  },
  data() {
    return {measurements: null, requestToken: null}
  },
  watch: {
    metric() {
      this.loadData();
    },
    from() {
      this.loadData();
    },
    to() {
      this.loadData();
    },
  },
  methods: {
    async fetchData() {
      if (this.requestToken) {
        this.requestToken.cancel('Operation canceled by the user.');
      }
      const params = {
        from: (this.from || moment().subtract(1, 'days')).format(API_DATE_FORMAT),
        to: (this.to || moment()).format(API_DATE_FORMAT)
      }

      this.requestToken = axios.CancelToken.source();
      const response = await axios.get(`/metrics/${this.metric.id}/measurements`, {
        cancelToken: this.requestToken.token,
        params
      });
      if (response.status !== 200) {
        this.error = `cannot fetch measurements: ${response.statusText} (http code = ${response.status})`;
        return;
      }
      this.measurements = response.data;
    },
  }
}
</script>

<style scoped>

</style>
