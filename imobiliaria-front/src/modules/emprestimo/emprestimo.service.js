import * as emprestimoResource from '@/modules/emprestimo/emprestimo.resource';

export function fetchEmprestimos() {
  return new Promise((resolve, reject) =>
    emprestimoResource
      .fetchEmprestimos()
      .then(({ data }) => {
        resolve({
          data,
        });
      })
      .catch(err => reject(err)));
}

export function getEmprestimo(emprestimoId) {
  return new Promise((resolve, reject) =>
    emprestimoResource
      .getEmprestimo(emprestimoId)
      .then(({ data }) => {
        if (!data) {
          reject(new Error('not_found'));
        }
        resolve({ data });
      })
      .catch(err => reject(err)));
}

export function saveEmprestimo(emprestimo) {
  const errors = null;
  return new Promise((resolve, reject) =>
    (errors ? reject(errors) : getEmprestimoSaveAction(emprestimo)(emprestimo)
      .then(({ data }) => resolve(data))
      .catch(err => reject(err))));
}

export function removeEmprestimo(emprestimo) {
  return new Promise((resolve, reject) =>
    emprestimoResource
      .removeEmprestimo(emprestimo.id)
      .then(() => {
        resolve();
      })
      .catch(err => {
        reject(err);
      }));
}

function getEmprestimoSaveAction(emprestimo) {
  return emprestimo.id ? emprestimoResource.updateEmprestimo : emprestimoResource.createEmprestimo;
}
