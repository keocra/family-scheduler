<script setup>
  const props = defineProps({
    index: {
      type: Number,
      required: true,
    },
  })

  import {ref, watch} from 'vue';

  import DateButton from './DateButton.vue'
  import DateRange from './DateRange.vue'
  import Trash from "./icons/trash.vue";

  const emit = defineEmits(['delete-person', 'person-name-change', 'person-date-range-change'])

  const person_name = ref("")

  watch(person_name, () => {
    emit('person-name-change')
  })

  const dates = ref(0)
  const dateRanges = ref([])
  watch(dateRanges, () => {
    emit('person-date-range-change')
  }, {deep: true})

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
    if (dateRanges.value.length === 0) {
      dates.value = 0
    }
  }

  const date_ranges = ref([])
  const index = ref(props.index)
  
  defineExpose({
    person_name,
    date_ranges,
    index
  })
</script>

<template>
  <br/>
  <div class="person">
    <h2 v-show="person_name !== ''">{{ person_name }}</h2>
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
                @delete-date="deleteDate(dateRange.pos)"
                @date-range-change="emit('person-date-range-change')"
                ref="date_ranges"
    />
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
