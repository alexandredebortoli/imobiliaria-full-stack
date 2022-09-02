<template>
  <div>
    <biblioteca-form v-if="emprestimoEditVm.emprestimo" :submit="save">
      <div class="form-field mt-4">
        <biblioteca-usuario-select
          ref="usuarioSelect"
          @on-change="onUsuarioChange" />
      </div>
      <div v-for="(livro, index) in maxLivros" :key="index" class="form-field mt-4">
        <biblioteca-livro-select
          ref="livroSelect"
          @on-change="onLivroChange($event, index)" />
        <biblioteca-button class="btn btn-danger" @click="onRemoverLivros(index)">
          Excluir Livro
        </biblioteca-button>
      </div>
      <biblioteca-button @click="onAddLivros">
        Adicionar Livros
      </biblioteca-button>

      <div class="mt-4 mb-3 d--flex justify-content-end">
        <biblioteca-button
          class="btn btn-secondary"
          width="110"
          size="sm"
          @click="goHistoryBack()">
          Cancelar
        </biblioteca-button>
        <biblioteca-button
          native-type="submit"
          class="btn btn-success ms-2"
          width="110"
          size="sm">
          <a v-if="emprestimoEditVm.emprestimo.id">Editar</a>
          <a v-else>Adicionar</a>
        </biblioteca-button>
      </div>
    </biblioteca-form>
  </div>
</template>

<script>
import { goHistoryBack } from '@/router/route.service';
import { toastError } from '@/services/toastService';

import BibliotecaLivroSelect from '@/modules/imovel/components/ImovelSelect.vue';
import BibliotecaUsuarioSelect from '@/modules/tipoimovel/components/TipoImovelSelect.vue';

export default {
  name: 'BibliotecaEmprestimoEdit',
  components: {
    BibliotecaLivroSelect,
    BibliotecaUsuarioSelect,
  },
  inject: ['emprestimoEditVm'],
  data() {
    return {
      value: 1,
      maxLivros: [],
      livroErro: false,
    };
  },
  mounted() {
    this.maxLivros.push(this.value);
  },
  methods: {
    goHistoryBack,
    save() {
      this.$emit('save');
    },
    onLivroChange(livroId, index) {
      this.emprestimoEditVm.emprestimo.livros.forEach(livro => {
        if (livro.id === livroId.id) {
          this.livroErro = true;
          this.onRemoverLivros(index);
          toastError('Livro já existe no empréstimo');
        }
      });
      if (!this.livroErro) {
        this.emprestimoEditVm.emprestimo.livros.push(livroId);
      }
      this.livroErro = false;
    },
    onUsuarioChange(usuario) {
      this.emprestimoEditVm.emprestimo.usuario = usuario;
    },
    onAddLivros() {
      this.value += 1;
      this.maxLivros.push({ id: this.value });
    },
    onRemoverLivros(index) {
      this.maxLivros.splice(index, 1);
      this.emprestimoEditVm.emprestimo.livros.splice(index, 1);
    },
  },
};
</script>
