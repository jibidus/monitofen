<template>
  <div>
    <Spinner v-if="loading" />
    <Error v-else-if="error">
      {{ error }}
    </Error>
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
import moment from 'moment-timezone';
import axios from "axios";
import MeasuresChart from "./MeasuresChart";
import Spinner from "./Spinner";
import Error from "./Error";
import {API_DATE_FORMAT} from '../constants';

export default {
  name: "MeasuresChartWrapper",
  components: {MeasuresChart, Spinner, Error},
  mixins: [FetchData],
  props: {
    metric: {type: Object, required: true},
    from: {type: Object, required: false, default: null},
    to: {type: Object, required: false, default: null}
  },
  data() {
    return {measures: null, requestToken: null}
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
      const response = await axios.get(`/metrics/${this.metric.id}/measures`, {
        cancelToken: this.requestToken.token,
        params
      });
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
