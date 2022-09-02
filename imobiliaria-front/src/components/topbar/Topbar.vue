<template>
  <biblioteca-navbar>
    <template #right>
      <div class="d-flex align-items--center">
        <biblioteca-button @click="onLivros">
          Imoveis
        </biblioteca-button>
        <biblioteca-button @click="onAdministradores">
          Administradores
        </biblioteca-button>
        <biblioteca-button @click="onUsuarios">
          Tipos de Imoveis
        </biblioteca-button>
        <biblioteca-button @click="onLogout">
          Sair
        </biblioteca-button>
      </div>
    </template>
  </biblioteca-navbar>
</template>

<script>
import { removeCookie } from '@/helpers/cookies/cookie';
import { goToLoginPage } from '@/router/route.service';
import { goToLivros, goToEmprestimos, goToUsuarios, goToAdministradores } from '@/modules/gerenciar/gerenciar.routes';

export default {
  name: 'BibliotecaTopbar',
  data() {
    return {
    };
  },
  methods: {
    removeCookie,
    onLogout() {
      removeCookie('session_id');
      goToLoginPage();
    },
    onLivros() {
      goToLivros(this.$router);
    },
    onEmprestimos() {
      goToEmprestimos(this.$router);
    },
    onUsuarios() {
      goToUsuarios(this.$router);
    },
    onAdministradores() {
      goToAdministradores(this.$router);
    },
  },
};
</script>
