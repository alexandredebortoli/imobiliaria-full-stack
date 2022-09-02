<template>
  <biblioteca-single-content-layout container-size="lg">
    <template #content>
      <div class="d--flex justify-content--space-between align-items--center">
        <biblioteca-header>Empréstimos</biblioteca-header>
        <biblioteca-button @click="onCreateEmprestimo">
          Adicionar Empréstimo
        </biblioteca-button>
      </div>
      <table v-if="emprestimoList && emprestimoList.length > 0" class="table">
        <tbody>
          <tr v-for="emprestimo in emprestimoList" :key="emprestimo.id">
            <td class="py-3 px-2">
              <biblioteca-header size="sm" class="d-flex align-item--center">
                <biblioteca-emprestimo-link :id="emprestimo.id">
                  Usuário: {{ emprestimo.usuario.nome }}
                </biblioteca-emprestimo-link>
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
            </td>
            <td class="align-middle text-end">
              <el-dropdown
                v-if="emprestimo.status != 2"
                trigger="click">
                <biblioteca-icon
                  icon="three-dots-vertical"
                  class="cursor--pointer mx--md" />
                <el-dropdown-menu slot="dropdown">
                  <el-dropdown-item>
                    <a @click="setDevolverEmprestimo(emprestimo)">
                      <biblioteca-icon size="sm" icon="send-check" />
                      Devolver
                    </a>
                  </el-dropdown-item>
                </el-dropdown-menu>
              </el-dropdown>
              <biblioteca-modal-delete
                v-if="showModal(emprestimo)"
                content="Você realmente deseja devolver o empréstimo?"
                @close="setDevolverEmprestimo(null)"
                @confirm="onDevolverEmprestimo(emprestimo)">
              </biblioteca-modal-delete>
            </td>
          </tr>
        </tbody>
      </table>
      <biblioteca-p v-else class="opacity--50 my--lg">( Sem empréstimos )</biblioteca-p>
    </template>
  </biblioteca-single-content-layout>
</template>

<script>
import moment from 'moment';

import { toastError } from '@/services/toastService';
import { EMPRESTIMO_STATUS } from '@/modules/emprestimo/emprestimo.constants';
import { fetchEmprestimos, saveEmprestimo } from '@/modules/emprestimo/emprestimo.service';
import { goToCreateEmprestimo } from '@/modules/emprestimo/emprestimo.routes';

import BibliotecaEmprestimoLink from '@/modules/emprestimo/components/EmprestimoLink.vue';
import BibliotecaSingleContentLayout from '@/layouts/SingleContentLayout.vue';

export default {
  name: 'BibliotecaGerenciarEmprestimos',
  components: {
    BibliotecaEmprestimoLink,
    BibliotecaSingleContentLayout,
  },
  data() {
    return {
      emprestimoList: [],
      emprestimoDevolver: null,
      statusInfo: EMPRESTIMO_STATUS,
    };
  },
  mounted() {
    this.fetch();
  },
  methods: {
    fetch() {
      this.emprestimoList = [];
      fetchEmprestimos()
        .then(data => {
          this.emprestimoList = data.data;
        })
        .catch(() => {
          this.emprestimoList = [];
        });
    },
    onCreateEmprestimo() {
      goToCreateEmprestimo(this.$router);
    },
    setDevolverEmprestimo(emprestimo) {
      this.emprestimoDevolver = emprestimo;
    },
    showModal(emprestimo) {
      return this.emprestimoDevolver && this.emprestimoDevolver.id === emprestimo.id;
    },
    onDevolverEmprestimo(emprestimo) {
      emprestimo.status = 2;
      saveEmprestimo(emprestimo)
        .then(() => {
        })
        .catch(() => toastError('Não foi possível devolver o empréstimo'));
    },
    formatarData(data) {
      return moment(data).format('DD/MM/YYYY');
    },
  },
};
</script>
