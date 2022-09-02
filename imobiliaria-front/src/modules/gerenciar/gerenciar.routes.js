import { GERENCIAR_URL } from '@/modules/gerenciar/gerenciar.constants';

export default [
  {
    ...GERENCIAR_URL.livros,
    component: () => import('@/modules/gerenciar/views/GerenciarLivros.vue'),
  },
  {
    ...GERENCIAR_URL.emprestimos,
    component: () => import('@/modules/gerenciar/views/GerenciarEmprestimos.vue'),
  },
  {
    ...GERENCIAR_URL.usuarios,
    component: () => import('@/modules/gerenciar/views/GerenciarUsuarios.vue'),
  },
  {
    ...GERENCIAR_URL.administradores,
    component: () => import('@/modules/gerenciar/views/GerenciarAdministradores.vue'),
  },
];

export function goToLivros($router) {
  $router.push({
    name: GERENCIAR_URL.livros.name,
  });
}

export function goToEmprestimos($router) {
  $router.push({
    name: GERENCIAR_URL.emprestimos.name,
  });
}

export function goToUsuarios($router) {
  $router.push({
    name: GERENCIAR_URL.usuarios.name,
  });
}
export function goToAdministradores($router) {
  $router.push({
    name: GERENCIAR_URL.administradores.name,
  });
}
