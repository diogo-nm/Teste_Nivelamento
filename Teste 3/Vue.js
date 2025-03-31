<template>
  <div class="container">
    <h1>Buscar Operadora</h1>
    <input v-model="searchQuery" placeholder="Digite o nome da operadora" />
    <button @click="buscar">Buscar</button>
    
    <ul v-if="operadoras.length">
      <li v-for="operadora in operadoras" :key="operadora.Registro_ANS">
        {{ operadora.Nome_Fantasia }} - {{ operadora.Razao_Social }}
      </li>
    </ul>
    <p v-else>Nenhum resultado encontrado.</p>
  </div>
</template>

<script>
import axios from 'axios';

export default {
  data() {
    return {
      searchQuery: '',
      operadoras: []
    };
  },
  methods: {
    async buscar() {
      if (!this.searchQuery) return;
      try {
        const response = await axios.get(`http://localhost:8000/buscar?q=${this.searchQuery}`);
        this.operadoras = response.data;
      } catch (error) {
        console.error("Erro ao buscar operadoras:", error);
      }
    }
  }
};
</script>

<style scoped>
.container {
  max-width: 600px;
  margin: auto;
  text-align: center;
}
input {
  padding: 8px;
  margin-right: 8px;
}
button {
  padding: 8px;
  cursor: pointer;
}
ul {
  list-style-type: none;
  padding: 0;
}
li {
  padding: 5px;
  border-bottom: 1px solid #ddd;
}
</style>
