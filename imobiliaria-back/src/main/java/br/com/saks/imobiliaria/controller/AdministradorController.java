package br.com.saks.imobiliaria.controller;

import br.com.saks.imobiliaria.config.JwtTokenUtil;
import br.com.saks.imobiliaria.model.JwtResponse;
import br.com.saks.imobiliaria.model.Administrador;
import br.com.saks.imobiliaria.service.JwtUserDetailsService;
import java.util.List;
import java.util.Optional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.DisabledException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.server.ResponseStatusException;
import br.com.saks.imobiliaria.repository.AdministradorRepository;

@RestController
@RequestMapping("/api/administradores")
public class AdministradorController {
    
    @Autowired
    private AdministradorRepository administradorRepository;
    
    @Autowired
    private AuthenticationManager authenticationManager;

    @Autowired
    private JwtTokenUtil jwtTokenUtil;

    @Autowired
    private JwtUserDetailsService userDetailsService;
    
    @GetMapping
    public List<Administrador> listarTodos() {
        return administradorRepository.findAll();
    }
    
    @GetMapping(value="/{id}")
    public Optional<Administrador> listarPeloId(@PathVariable Long id) {
        return administradorRepository.findById(id);
    }
    
    @PostMapping
    public Administrador adicionarAdministrador(@RequestBody Administrador administrador) {
        BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();
        administrador.setSenha(encoder.encode(administrador.getSenha()));
        return administradorRepository.save(administrador);
    }
    
    @RequestMapping(value = "/criar", method = RequestMethod.POST)
    public ResponseEntity<?> adicionar(@RequestBody Administrador administrador) {
        try {
            BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();
            String senha = administrador.getSenha();
            administrador.setSenha(encoder.encode(administrador.getSenha()));

            Administrador administradorSave = administradorRepository.save(administrador);
            authenticate(administradorSave.getEmail(), senha);
            final UserDetails userDetails = userDetailsService
                    .loadUserByUsername(administradorSave.getEmail());
            final String token = jwtTokenUtil.generateToken(userDetails);
            return ResponseEntity.ok(new JwtResponse(token));
        } catch (Exception e) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "EMAIL_DUPLICADO");
        }
    }

    private void authenticate(String username, String password) throws Exception {
        try {
            authenticationManager.authenticate(new UsernamePasswordAuthenticationToken(username, password));
        } catch (DisabledException e) {
            throw new Exception("USER_DISABLED", e);
        } catch (BadCredentialsException e) {
            throw new Exception("INVALID_CREDENTIALS", e);
        }
    }
    
    @PutMapping(value="/{id}")
    public ResponseEntity editar(@PathVariable Long id, @RequestBody Administrador administrador) {
        BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();
        administrador.setSenha(encoder.encode(administrador.getSenha()));
        return administradorRepository.findById(id)
                .map(record -> {
                    record.setNome(administrador.getNome());
                    record.setEmail(administrador.getEmail());
                    record.setSenha(administrador.getSenha());
                    record.setStatus(administrador.getStatus());
                    Administrador administradorUpdated = administradorRepository.save(record);
                    return ResponseEntity.ok().body(administradorUpdated);
                }).orElse(ResponseEntity.notFound().build());
    }
    
    @DeleteMapping(value="/{id}")
    public ResponseEntity deletar(@PathVariable Long id) {
        return administradorRepository.findById(id)
                .map(record-> {
                    administradorRepository.deleteById(id);
                    return ResponseEntity.ok().build();
                }).orElse(ResponseEntity.notFound().build());
    }
}
