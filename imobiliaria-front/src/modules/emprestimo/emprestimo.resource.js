import { get, post, put, remove } from '@/helpers/http';

const BASE_PATH = 'emprestimos';

export function fetchEmprestimos() {
  return get(`${BASE_PATH}`);
}

export function getEmprestimo(emprestimoId) {
  return get(`${BASE_PATH}/${emprestimoId}`);
}

export function createEmprestimo(emprestimo) {
  return post(`${BASE_PATH}`, { ...emprestimo });
}

export function updateEmprestimo(emprestimo) {
  return put(`${BASE_PATH}/${emprestimo.id}`, emprestimo);
}

export function removeEmprestimo(id) {
  return remove(`${BASE_PATH}/${id}`);
}
