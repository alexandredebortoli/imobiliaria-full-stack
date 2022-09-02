import { post } from '@/helpers/http';

export function login(username, password) {
  return post('/authenticate', { username, password });
}

export function registrar(usuario) {
  return post('/administradores/criar', usuario);
}
