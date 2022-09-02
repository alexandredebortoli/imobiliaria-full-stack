package br.com.saks.imobiliaria.controller;

import br.com.saks.imobiliaria.model.TipoImovel;
import java.util.List;
import java.util.Optional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import br.com.saks.imobiliaria.repository.TipoImovelRepository;

@RestController
@RequestMapping("/api/tipos-imoveis")
public class TipoImovelController {
    
    @Autowired
    private TipoImovelRepository tipoRepository;
    
    @Cacheable("listarTodos")
    @GetMapping
    public List<TipoImovel> listarTodos() {
        return tipoRepository.findAll();
    }
    
    @Cacheable("listarPeloId")
    @GetMapping(value="/{id}")
    public Optional<TipoImovel> listarPeloId(@PathVariable Long id) {
        return tipoRepository.findById(id);
    }

    @PostMapping
    public TipoImovel adicionar(@RequestBody TipoImovel tipoImovel) {
        return tipoRepository.save(tipoImovel);
    }
    
    @PutMapping(value="/{id}")
    public ResponseEntity editar(@PathVariable Long id, @RequestBody TipoImovel tipoImovel) {
        return tipoRepository.findById(id)
                .map(record -> {
                    record.setNome(tipoImovel.getNome());
                    TipoImovel tipoImovelUpdated = tipoRepository.save(record);
                    return ResponseEntity.ok().body(tipoImovelUpdated);
                }).orElse(ResponseEntity.notFound().build());
    }
    
    @DeleteMapping(value="/{id}")
    public ResponseEntity deletar(@PathVariable Long id) {
        return tipoRepository.findById(id)
                .map(record-> {
                    tipoRepository.deleteById(id);
                    return ResponseEntity.ok().build();
                }).orElse(ResponseEntity.notFound().build());
    }
}
