<template>
  <router-link :to="to">
    <slot />
  </router-link>
</template>
<script>
import { EMPRESTIMOS_URL } from '@/modules/emprestimo/emprestimo.constants';

export default {
  name: 'BibliotecaEmprestimoLink',
  props: {
    id: {
      type: Number,
      required: true,
    },
    action: {
      type: String,
      default: 'view',
      validator(action) {
        return action && ['view', 'edit'].includes(action);
      },
    },
  },
  computed: {
    to() {
      return {
        name: EMPRESTIMOS_URL[this.action].name,
        path: EMPRESTIMOS_URL[this.action].path,
        params: {
          id: this.id,
        },
      };
    },
  },
};
</script>
