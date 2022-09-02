<template>
  <biblioteca-container class="d-flex justify-content-center align-items-center h-100 py--xl">
    <biblioteca-form v-slot="{ validate }" :submit="submitLogin">
      <div class="text-center mb-3">
        <img
          class="mb-2"
          src="@/assets/images/logo.png"
          alt=""
          width="80" />
        <biblioteca-header size="md">Imobiliaria</biblioteca-header>
        <small>Entrar</small>
      </div>
      <div class="mb-3">
        <biblioteca-input
          v-model="username"
          type="email"
          name="e-mail"
          rules="required|email"
          placeholder="E-mail"
          :focus="true" />
      </div>
      <div class="mb-3">
        <biblioteca-input
          v-model="password"
          name="senha"
          type="password"
          rules="required|min:6"
          placeholder="Senha" />
      </div>
      <div class="d-grid mb-3">
        <biblioteca-button
          class="btn btn-primary"
          native-type="submit"
          @click="validate">
          Entrar
        </biblioteca-button>
      </div>
      <div class="d-grid text-center">
        <p>
          Não possui conta?
          <router-link class="color--primary" to="/registrar">Criar conta</router-link>
        </p>
      </div>
    </biblioteca-form>
  </biblioteca-container>
</template>

<script>
import * as authStore from '@/modules/auth/auth.store';
import { toastError } from '@/services/toastService';
import { passwordLogin } from '@/modules/auth/auth.service';
import { goToBasePage } from '@/router/route.service';

export default {
  name: 'BibliotecaLoginPage',
  data() {
    return {
      username: '',
      password: '',
    };
  },
  beforeCreate() {
    if (authStore.getters.getToken()) {
      goToBasePage();
    }
  },
  methods: {
    submitLogin() {
      passwordLogin(this.username, this.password)
        .then(goToBasePage)
        .catch(err => {
          if (err.response.data.message === 'USUARIO_INCORRETO') {
            toastError('E-mail e/ou senha incorretos');
          }
        });
    },
  },
};
</script>
<style scoped>
span {
  width: 320px;
}
</style>
