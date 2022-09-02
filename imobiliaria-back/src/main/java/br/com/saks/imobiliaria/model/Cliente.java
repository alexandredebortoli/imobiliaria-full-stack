package br.com.saks.imobiliaria.model;

import com.fasterxml.jackson.annotation.JsonIgnore;
import java.util.List;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.ManyToMany;
import lombok.Data;

@Data
@Entity
public class Cliente {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @JsonIgnore
    @ManyToMany(mappedBy = "clientes")
    private List<Imovel> imoveis;
    
    @Column(length = 100)
    private String nome;
    
    @Column(nullable = false, unique = true, length = 200)
    private String email;
    
    @Column(nullable = false, length = 200)
    private String senha;
    
    @Column(length = 15)
    private String telefone;
}
