<script setup>
const emit = defineEmits(['create-person'])

const createPerson = () => {
  emit('create-person')
}
</script>

<template>
<div>
  <button class="green" @click="createPerson">Add person</button>
</div>
</template>

<style scoped>
button {
  padding: 0.6em 1.2em;
  font-size: 1em;
  font-weight: 500;
  font-family: inherit;
  cursor: pointer;
  border: 1px solid transparent;
  border-radius: 4px;
  transition: border-color 0.25s;
}

button:hover {
  border-color: #42b983;
}
</style>
