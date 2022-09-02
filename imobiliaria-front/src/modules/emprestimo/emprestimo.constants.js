export const EMPRESTIMOS_URL = Object.freeze({
  path: '/emprestimos',
  view: {
    name: 'emprestimo.view',
    path: '/emprestimos/ver/:id',
  },
  edit: {
    name: 'emprestimo.edit',
    path: '/emprestimos/editar/:id',
  },
  create: {
    name: 'emprestimo.create',
    path: '/emprestimos/criar',
  },
  notfound: {
    name: 'emprestimo.notfound',
    path: '/emprestimos/nao-encontrado',
  },
});

export const EMPRESTIMO_ERRORS = {
  404: 'EMPRESTIMO_NOT_FOUND',
  401: 'PERMISSION_DENIED',
};

export const EMPRESTIMO_STATUS = {
  0: 'Cancelado',
  1: 'Ativo',
  2: 'Devolvido',
};
