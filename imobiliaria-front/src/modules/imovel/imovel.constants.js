export const LIVROS_URL = Object.freeze({
  path: '/imoveis',
  view: {
    name: 'livro.view',
    path: '/imoveis/ver/:id',
  },
  edit: {
    name: 'livro.edit',
    path: '/imoveis/editar/:id',
  },
  create: {
    name: 'livro.create',
    path: '/imoveis/criar',
  },
  notfound: {
    name: 'livro.notfound',
    path: '/imoveis/nao-encontrado',
  },
});

export const LIVRO_ERRORS = {
  404: 'LIVRO_NOT_FOUND',
  401: 'PERMISSION_DENIED',
};
