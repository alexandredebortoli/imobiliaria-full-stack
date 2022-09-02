package br.com.saks.imobiliaria.controller;

import br.com.saks.imobiliaria.config.JwtTokenUtil;
import br.com.saks.imobiliaria.model.JwtResponse;
import br.com.saks.imobiliaria.model.Cliente;
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
import br.com.saks.imobiliaria.repository.ClienteRepository;

@RestController
@RequestMapping("/api/clientes")
public class ClienteController {
    
    @Autowired
    private ClienteRepository clienteRepository;
    
    @Autowired
    private AuthenticationManager authenticationManager;

    @Autowired
    private JwtTokenUtil jwtTokenUtil;

    @Autowired
    private JwtUserDetailsService userDetailsService;
    
    @GetMapping
    public List<Cliente> listarTodos() {
        return clienteRepository.findAll();
    }
    
    @GetMapping(value="/{id}")
    public Optional<Cliente> listarPeloId(@PathVariable Long id) {
        return clienteRepository.findById(id);
    }
    
    @PostMapping
    public Cliente adicionarCliente(@RequestBody Cliente cliente) {
        BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();
        cliente.setSenha(encoder.encode(cliente.getSenha()));
        return clienteRepository.save(cliente);
    }
    
    @RequestMapping(value = "/criar", method = RequestMethod.POST)
    public ResponseEntity<?> adicionar(@RequestBody Cliente cliente) {
        try {
            BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();
            String senha = cliente.getSenha();
            cliente.setSenha(encoder.encode(cliente.getSenha()));

            Cliente clienteSave = clienteRepository.save(cliente);
            authenticate(clienteSave.getEmail(), senha);
            final UserDetails userDetails = userDetailsService
                    .loadUserByUsername(clienteSave.getEmail());
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
    public ResponseEntity editar(@PathVariable Long id, @RequestBody Cliente cliente) {
        BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();
        cliente.setSenha(encoder.encode(cliente.getSenha()));
        return clienteRepository.findById(id)
                .map(record -> {
                    record.setNome(cliente.getNome());
                    record.setEmail(cliente.getEmail());
                    record.setSenha(cliente.getSenha());
                    record.setTelefone(cliente.getTelefone());
                    Cliente clienteUpdated = clienteRepository.save(record);
                    return ResponseEntity.ok().body(clienteUpdated);
                }).orElse(ResponseEntity.notFound().build());
    }
    
    @DeleteMapping(value="/{id}")
    public ResponseEntity deletar(@PathVariable Long id) {
        return clienteRepository.findById(id)
                .map(record-> {
                    clienteRepository.deleteById(id);
                    return ResponseEntity.ok().build();
                }).orElse(ResponseEntity.notFound().build());
    }
}
