<script setup>
import AddPersonButton from './components/AddPersonButton.vue'
import PersonComponent from './components/Person.vue'
import {ref} from 'vue'

const persons = ref([])

const createPerson = () => {
  persons.value.push({name: ""})
}
</script>

<template>
  <main>
    <header>
      <div class="wrapper">
        <h1 class="green">Family Scheduler</h1>
      </div>
    </header>
    <add-person-button @click="createPerson"/>
    <person-component v-for="person in persons" :key="person.id"/>
  </main>
</template>

<style scoped>
header {
  line-height: 1.5;
}

.logo {
  display: block;
  margin: 0 auto 2rem;
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
