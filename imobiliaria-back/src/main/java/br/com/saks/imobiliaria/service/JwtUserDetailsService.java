package br.com.saks.imobiliaria.service;

import br.com.saks.imobiliaria.model.Administrador;
import java.util.ArrayList;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;
import br.com.saks.imobiliaria.repository.AdministradorRepository;

@Service
public class JwtUserDetailsService implements UserDetailsService {

	@Autowired
    private AdministradorRepository administradorRepository;
	
	@Override
	public UserDetails loadUserByUsername(String email) throws UsernameNotFoundException {
		Optional<Administrador> usuarioResponse = administradorRepository.findByEmail(email);
                Administrador usuario = usuarioResponse.get();
		
		if (usuario.getEmail().equals(email)) {
			return new User(email, usuario.getSenha(),
					new ArrayList<>());
		} else {
			throw new UsernameNotFoundException("usuário não encontrado - email: " + email);
		}
	}
}