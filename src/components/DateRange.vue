<script setup>
defineProps({
  pos: {
    type: Number,
    required: true,
  },
})

import { ref } from 'vue';
import Trash from './icons/trash.vue'

const emit = defineEmits(['delete-date', "date-range-change"])

const label = ref("")
const startDate = ref(null);
const endDate = ref(null);

const handleDelete = () => {
  emit('delete-date');
}

defineExpose({
  label,
  startDate,
  endDate
})
</script>

<template>
<div>
  From (including): <input type="date" v-model="startDate" @change="$emit('date-range-change')"/>
  Until (including): <input type="date" v-model="endDate" @change="$emit('date-range-change')"/>
  Label: <input type="text" v-model="label" @change="$emit('date-range-change')"/>
  <div class="delete-container">
    <button class="icon-button" @click="handleDelete">
    <Trash/>
    </button>
  </div>
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
