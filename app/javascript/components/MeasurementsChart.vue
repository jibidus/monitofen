<template>
  <div class="chart-container">
    <canvas
      id="chart"
      ref="chart"
      data-testid="chart"
    />
  </div>
</template>

<script>
import Chart from "chart.js/auto";
import moment from "moment-timezone";
import 'chartjs-adapter-moment';

export default {
  name: "MeasurementsChart",
  props: {
    measurements: {required: true, type: Array},
    metricLabel: {required: true, type: String},
  },
  data() {
    return {
      chart: null
    };
  },
  computed: {
    parsedMeasurements() {
      return this.measurements.map(m => ({
        date: moment(m.date),
        value: m.value
      }));
    }
  },
  mounted() {
    this.drawChart();
  },
  unmounted() {
    this.chart.clear();
    this.chart.destroy();
  },
  methods: {
    drawChart() {
      const ctx = this.$refs.chart.getContext('2d');
      this.chart = new Chart(ctx, {
        type: 'line',
        data: {
          labels: this.parsedMeasurements.map(m => m.date),
          datasets: [
            {
              label: this.metricLabel,
              data: this.measurements.map(m => m.value),
              fill: false,
              borderColor: 'rgb(75, 192, 192)',
              tension: 0.1,
            }
          ]
        },
        options: {
          responsive: true,
          maintainAspectRatio: false,
          locale: 'en-EN',
          plugins: {
            legend: {
              display: false,
            }
          },
          scales: {
            xAxes: {
              type: 'time',
              time: {
                displayFormats: {
                  hour: 'ha'
                }
              },
            }
          },
          pointRadius: 0
        }
      });
    }
  }
}
</script>

<style scoped>
.chart-container {
  position: relative;
  margin: auto;
  min-height: 60vh;
}
</style>
