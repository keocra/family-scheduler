<script setup>
import AddPersonButton from './components/AddPersonButton.vue'
import Person from './components/Person.vue'
import {ref, watch} from 'vue'

import { GChart } from 'vue-google-charts'

const chartData = ref([])

const persons = ref([])
const personId = ref(0)
const personRefs = ref([])

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
                                                  return {
                                                    label: dateRange.label ? dateRange.label : "",
                                                    startDate: new Date(dateRange.startDate),
                                                    endDate: new Date(dateRange.endDate)
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
  </main>
</template>

<style scoped>

</style>
