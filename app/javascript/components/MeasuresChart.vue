<template>
  <div
    id="chart"
    ref="chart"
    data-testid="chart"
  />
</template>

<script>
import * as d3 from "d3";

export default {
  name: "TheChart",
  props: {
    measures: {required: true, type: Array},
  },
  data() {
    return {
      width: 750,
      height: 400,
      margin: {
        top: 50,
        right: 50,
        left: 50,
        bottom: 50,
      },
    }
  },
  computed: {
    parsedMeasures() {
      const parseDate = d3.timeParse("%Y-%m-%dT%H:%M:%S.%LZ");
      return this.measures.map(m => ({date: parseDate(m.date), value: m.value}))
    }
  },
  mounted() {
    this.drawChart()
  },
  methods: {
    drawChart() {
      const svg = d3.select(this.$refs.chart)
        .append("svg")
        .attr("width", this.width + this.margin.left + this.margin.right)
        .attr("height", this.height + this.margin.top + this.margin.bottom)
        .append("g")
        .attr("transform",
          "translate(" + this.margin.left + "," + this.margin.top + ")");

      // Add X axis
      // We get a function which map values to pixels according the axis
      const x = d3.scaleTime()
        // extent compute mininum and maximum
        .domain(d3.extent(this.parsedMeasures, m => m.date))
        .range([0, this.width]);
      svg.append("g")
        .attr("transform", "translate(0," + this.height + ")")
        .call(d3.axisBottom(x));

      // Add Y axis
      const y = d3.scaleLinear()
        .domain([0, d3.max(this.parsedMeasures, m => m.value)])
        .range([this.height, 0]);
      svg.append("g")
        .call(d3.axisLeft(y));

      // Add the line
      svg.append("path")
        .datum(this.parsedMeasures)
        .attr("fill", "none")
        .attr("stroke", "steelblue")
        .attr("stroke-width", 1.5)
        .attr("d", d3.line()
          .x(m => x(m.date))
          .y(m => y(m.value))
        )
    }
  }
}
</script>

<style scoped>

</style>
