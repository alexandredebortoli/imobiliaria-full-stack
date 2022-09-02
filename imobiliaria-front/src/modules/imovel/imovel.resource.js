import { get, post, put, remove } from '@/helpers/http';

const BASE_PATH = 'imoveis';

export function fetchLivros() {
  return get(`${BASE_PATH}`);
}

export function getLivro(livroId) {
  return get(`${BASE_PATH}/${livroId}`);
}

export function createLivro(livro) {
  return post(`${BASE_PATH}`, { ...livro });
}

export function updateLivro(livro) {
  return put(`${BASE_PATH}/${livro.id}`, livro);
}

export function removeLivro(id) {
  return remove(`${BASE_PATH}/${id}`);
}
