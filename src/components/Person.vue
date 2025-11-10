<script setup>
  defineProps({
    index: {
      type: Number,
      required: true,
    },
  })

  import { ref } from 'vue';

  import DateButton from './DateButton.vue'
  import DateRange from './DateRange.vue'
  import Trash from "./icons/trash.vue";

  const emit = defineEmits(['delete-person'])

  const person_name = ref("")

  const dates = ref(0)
  const dateRanges = ref([])

  const createDate = () => {
    dateRanges.value.push({pos: dates.value++});
  }

  const handleDelete = () => {
    emit('delete-person');
  }

  const deleteDate = (pos) => {
    if (pos === undefined) {
      return
    }
    dateRanges.value = dateRanges.value.filter(dateRange => dateRange.pos !== pos)
  }
</script>

<template>
  <br/>
  <div class="person">
    <h2 v-visible="person_name !== ''">{{ person_name }}</h2>
    Persons name: <input
          type="text"
          v-model="person_name"
      />
    <br/>
    Delete person:
    <div class="delete-container">
      <button class="icon-button" @click="handleDelete">
        <Trash/>
      </button>
    </div>
    <br/>
    Date ranges:<br/>
    <date-button @click="createDate"/>
    <date-range v-for="dateRange in dateRanges" :key="dateRange.pos" :pos="dateRange.pos"
                @delete-date="deleteDate(dateRange.pos)"/>
  </div>
</template>

<style scoped>
.delete-container {
  display: inline-block;
  margin-left: 10px;
}

.icon-button {
  height: 26px;
  width: 26px;
  background: none;
  border: none;
  cursor: pointer;
  padding: 5px;
}

.icon-button:hover {
  opacity: 0.7;
}
</style>
