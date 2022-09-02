<template>
  <biblioteca-row>
    <biblioteca-col
      :sm="4"
      :md="2">
      <biblioteca-icon
        class="mt-2"
        size="xl"
        icon="send" />
    </biblioteca-col>
    <biblioteca-col
      :sm="20"
      :md="22">
      <biblioteca-header v-truncate size="sm">
        <biblioteca-emprestimo-link :id="emprestimo.id">{{ emprestimo.usuario.nome }}</biblioteca-emprestimo-link>
      </biblioteca-header>
      <biblioteca-p color="regular">
        Quantidade de livros: {{ emprestimo.livros.length }}
      </biblioteca-p>
      <biblioteca-p color="regular">
        Status: {{ statusInfo[emprestimo.status] }}
      </biblioteca-p>
      <biblioteca-p color="regular">
        Data Retirada: {{ formatarData(emprestimo.dataRetirada) }}
      </biblioteca-p>
    </biblioteca-col>
  </biblioteca-row>
</template>

<script>
import moment from 'moment';

import { EMPRESTIMO_STATUS } from '@/modules/emprestimo/emprestimo.constants';

import BibliotecaEmprestimoLink from '@/modules/emprestimo/components/EmprestimoLink.vue';

export default {
  name: 'EmprestimoListItem',
  components: {
    BibliotecaEmprestimoLink,
  },
  props: {
    emprestimo: {
      type: Object,
      required: true,
    },
  },
  data() {
    return {
      statusInfo: EMPRESTIMO_STATUS,
    };
  },
  methods: {
    formatarData(data) {
      return moment(data).format('DD/MM/YYYY');
    },
  },
};
</script>
