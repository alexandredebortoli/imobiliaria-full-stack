import { EMPRESTIMOS_URL } from '@/modules/emprestimo/emprestimo.constants';
import { createEmptyComponent } from '@/router/route.service';

export default [
  {
    path: EMPRESTIMOS_URL.path,
    redirect: '/',
    component: { render: createEmptyComponent },
    children: [
      {
        ...EMPRESTIMOS_URL.view,
        component: () => import('@/modules/emprestimo/views/EmprestimoViewPage.vue'),
      },
      {
        ...EMPRESTIMOS_URL.edit,
        component: () => import('@/modules/emprestimo/views/EmprestimoEditPage.vue'),
      },
      {
        ...EMPRESTIMOS_URL.create,
        component: () => import('@/modules/emprestimo/views/EmprestimoEditPage.vue'),
      },
      {
        ...EMPRESTIMOS_URL.notfound,
        component: () => import('@/modules/emprestimo/views/EmprestimoNotFound.vue'),
      },
    ],
  },
];

export function goToEmprestimoNotFound($router) {
  $router.push({
    name: EMPRESTIMOS_URL.notfound.name,
  });
}

export function goToOpenEmprestimo($router, emprestimo) {
  $router.push({
    name: EMPRESTIMOS_URL.view.name,
    params: { id: emprestimo.id },
  });
}

export function goToCreateEmprestimo($router) {
  $router.push({
    name: EMPRESTIMOS_URL.create.name,
  });
}
