<script setup>
import AddPersonButton from './components/AddPersonButton.vue'
import Person from './components/Person.vue'
import {ref, watch, onMounted} from 'vue'

import { GChart } from 'vue-google-charts'
import * as d3 from 'd3'

const chartData = ref([])

const persons = ref([])
const personId = ref(0)
const personRefs = ref([])

const timeline = ref(null)
const availableColors = [
  '#4285f4',
  '#f08080',
  '#ffd700',
  '#808000',
  '#008080',
  '#69b3a2',
  '#000080',
  '#800080',
  '#808080',
  '#c0c0c0',
  '#ff0000',
  '#ffa500',
  '#ffff00',
  '#00ff00',
  '#00ffff',
  '#0000ff',
  '#8000ff',
  '#ff00ff',
]

const createPerson = () => {
  const person = {
    id: personId.value++
  }
  persons.value.push(person)
}
const deletePerson = (pos) => {
  if (pos === undefined) {
    return
  }
  persons.value = persons.value.filter(person => person.id !== pos)
  if (persons.value.length === 0) {
    personId.value = 0
  }
}

function assignLanes(data) {
  const grouped = d3.group(data, d => d.name)
  const result = []

  for (const [name, items] of grouped) {
    const lanes = []
    items.sort((a, b) => a.start - b.start)

    for (const item of items) {
      let lane = 0
      while (lanes[lane] && lanes[lane] > item.start) {
        lane++
      }
      lanes[lane] = item.end
      result.push({ ...item, lane })
    }
  }

  return result
}

const show_timeline = ref(false)
const re_render_timeline = () => {
  show_timeline.value = false
  let intChartData = personRefs.value
                        .filter(person => person.date_ranges !== undefined && person.date_ranges.length > 0)
                        .filter(person => person.date_ranges.some(dateRange => dateRange.startDate !== undefined && dateRange.startDate !== null && dateRange.endDate !== undefined && dateRange.endDate !== null && dateRange.startDate !== "" && dateRange.endDate !== ""))
  let intChartData2 = intChartData
                        .map(person => {
                          let name = person.person_name
                          if (name === undefined || name === "") {
                            name = "<<Unnamed " + person.index + ">>"
                          }
                          return {
                            id: person.index,
                            name: name,
                            date_ranges: person.date_ranges
                                                .filter(dateRange => dateRange.startDate !== undefined && dateRange.startDate !== null && dateRange.endDate !== undefined && dateRange.endDate !== null && dateRange.startDate !== "" && dateRange.endDate !== "")
                                                .map(dateRange => {
                                                  let endDate = new Date(dateRange.endDate)
                                                  endDate.setDate(endDate.getDate() + 1)
                                                  return {
                                                    label: dateRange.label ? dateRange.label : "",
                                                    startDate: new Date(dateRange.startDate),
                                                    endDate: endDate
                                                  }
                                                })
                          }
                        })
  if (intChartData2.length === 0) {
    chartData.value = []
    return
  }

  let tmpChartData = [
    ['Person', 'Label', 'Start', 'End']
  ]
  for (const person of intChartData2) {
    for (const dateRange of person.date_ranges) {
      tmpChartData.push([person.name, dateRange.label, dateRange.startDate, dateRange.endDate])
    }
  }
  chartData.value = tmpChartData


  // ===============================================================================================
  d3.select(timeline.value).selectAll("*").remove()

  const rawData = []
  for (const person of intChartData2) {
    for (const dateRange of person.date_ranges) {
      rawData.push({ name: person.name, start: dateRange.startDate, end: dateRange.endDate, color: availableColors[person.id % availableColors.length] })
    }
  }
  const data = assignLanes(rawData)

  const margin = { top: 20, right: 30, bottom: 30, left: 120 }
  const laneHeight = 20
  const lanePadding = 5
  const width = 1500 - margin.left - margin.right

  const names = Array.from(new Set(data.map(d => d.name)))
  const yName = d3.scaleBand()
  .domain(names)
  .range([0, names.length * laneHeight * 3]) // max 3 lanes per name
  .paddingInner(0.3)

  const x = d3.scaleTime()
  .domain([d3.min(data, d => d.start), d3.max(data, d => d.end)])
  .range([0, width])

  const svg = d3.select(timeline.value)
  .append('svg')
  .attr('width', width + margin.left + margin.right)
  .attr('height', yName.range()[1] + margin.top + margin.bottom)
  .append('g')
  .attr('transform', `translate(${margin.left},${margin.top})`)

  svg.append('g')
  .call(d3.axisLeft(yName))

  svg.append('g')
  .attr('transform', `translate(0,${yName.range()[1]})`)
  .call(d3.axisBottom(x))

  svg.selectAll('rect')
  .data(data)
  .enter()
  .append('rect')
  .attr('x', d => x(d.start))
  .attr('y', d => yName(d.name) + d.lane * (laneHeight + lanePadding))
  .attr('width', d => x(d.end) - x(d.start))
  .attr('height', laneHeight)
  .attr('fill', d => d.color)
  // ===============================================================================================


  show_timeline.value = true
}
watch(personRefs, () => {
  re_render_timeline()
}, {deep: true})
</script>

<template>
  <main>
    <header>
      <div class="wrapper">
        <h1 class="green">Family Scheduler</h1>
      </div>
    </header>
    <add-person-button @click="createPerson()"/>
    <Person v-for="(person, _) in persons" :index="person.id" :key="person.id"
                      @delete-person="deletePerson(person.id)"
                      @person-date-range-change="re_render_timeline()"
                      @person-name-change="re_render_timeline()"
                      ref="personRefs"
    />
    <br/>
    <div v-if="show_timeline">
      <h2>Timeline:</h2>
      <GChart
          id="timeline"
          type="Timeline"
          :data="chartData"
          :settings="{ packages: ['timeline'] }"
          :options="{ height: chartData.length * 41 + 30 }"
      />
    </div>
    <div v-show="show_timeline" ref="timeline" class="timeline-container"></div>
  </main>
</template>

<style scoped>
.timeline-container {
  max-width: 1500px;
  margin: 0
}
</style>
