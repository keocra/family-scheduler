<script setup>
import AddPersonButton from './components/AddPersonButton.vue'
import Person from './components/Person.vue'
import {ref} from 'vue'

import { GChart } from 'vue-google-charts'

const chartData = [
    ['Person', 'Start', 'End'],
  [ 'Washington', new Date(1789, 3, 30), new Date(1797, 2, 4) ],
  [ 'Adams',      new Date(1797, 2, 4),  new Date(1801, 2, 4) ],
  [ 'Jefferson',  new Date(1801, 2, 4),  new Date(1809, 2, 4) ]
]

const persons = ref([])
const personId = ref(0)

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
                      @delete-person="deletePerson(person.id)"/>
    <br/>
    <div v-if="persons.length > 0">
      <h2>Timeline:</h2>
      <GChart
          type="Timeline"
          :data="chartData"
          :settings="{ packages: ['timeline'] }"
      />
    </div>
  </main>
</template>

<style scoped>
header {
  line-height: 1.5;
}

@media (min-width: 1024px) {
  header {
    display: flex;
    place-items: center;
    padding-right: calc(var(--section-gap) / 2);
  }

  .logo {
    margin: 0 2rem 0 0;
  }

  header .wrapper {
    display: flex;
    place-items: flex-start;
    flex-wrap: wrap;
  }
}
</style>
