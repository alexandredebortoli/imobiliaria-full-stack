<template>
  <biblioteca-single-content-layout container-size="lg">
    <template v-if="emprestimo" #content>
      <biblioteca-row class="d-flex align-items-center">
        <biblioteca-col>
          <biblioteca-header>
            <biblioteca-usuario-link :id="emprestimo.usuario.id" target="_blank">
              Usuário: {{ emprestimo.usuario.nome }}
            </biblioteca-usuario-link>
          </biblioteca-header>
        </biblioteca-col>
      </biblioteca-row>
      <biblioteca-row class="mt-1">
        <biblioteca-col>
          <biblioteca-p class="biblioteca-u-text--medium">
            Status: {{ statusInfo[emprestimo.status] }}
          </biblioteca-p>
        </biblioteca-col>
      </biblioteca-row>
      <biblioteca-row class="mt-1">
        <biblioteca-col>
          <biblioteca-p class="biblioteca-u-text--medium">
            Data Retirada: {{ formatarData(emprestimo.dataRetirada) }}
          </biblioteca-p>
        </biblioteca-col>
      </biblioteca-row>
      <biblioteca-row class="mt-1">
        <biblioteca-col>
          <biblioteca-p class="biblioteca-u-text--medium">
            Livros:
          </biblioteca-p>
          <biblioteca-p v-for="livro in emprestimo.livros" :key="livro" class="biblioteca-u-text--medium">
            <biblioteca-livro-link :id="livro.id" target="_blank">
              • {{ livro.titulo }}
            </biblioteca-livro-link>
          </biblioteca-p>
        </biblioteca-col>
      </biblioteca-row>
    </template>
  </biblioteca-single-content-layout>
</template>

<script>
import moment from 'moment';

import { EMPRESTIMO_ERRORS, EMPRESTIMO_STATUS } from '@/modules/emprestimo/emprestimo.constants';
import { getEmprestimo } from '@/modules/emprestimo/emprestimo.service';
import { toastError } from '@/services/toastService';
// eslint-disable-next-line import/no-cycle
import { goToEmprestimoNotFound } from '@/modules/emprestimo/emprestimo.routes';
import BibliotecaSingleContentLayout from '@/layouts/SingleContentLayout.vue';
import BibliotecaUsuarioLink from '@/modules/tipoimovel/components/TipoImovelLink.vue';
import BibliotecaLivroLink from '@/modules/imovel/components/ImovelLink.vue';

export default {
  name: 'EmprestimoViewPage',
  components: {
    BibliotecaUsuarioLink,
    BibliotecaLivroLink,
    BibliotecaSingleContentLayout,
  },
  data() {
    return {
      emprestimo: null,
      statusInfo: EMPRESTIMO_STATUS,
    };
  },
  computed: {
    id() {
      return this.$route.params?.id;
    },
  },
  mounted() {
    this.fetch();
  },
  methods: {
    fetch() {
      getEmprestimo(this.id)
        .then(({ data }) => {
          this.emprestimo = data;
        })
        .catch(err => {
          this.emprestimo = null;
          if (err) {
            goToEmprestimoNotFound(this.$router);
          } else if ((err.response.data.errors === EMPRESTIMO_ERRORS[err.response.status] && err.response.status === 404)) {
            goToEmprestimoNotFound(this.$router);
          } else {
            toastError('Erro ao buscar o empréstimo');
          }
        });
    },
    formatarData(data) {
      return moment(data).format('DD/MM/YYYY');
    },
  },
};
</script>
