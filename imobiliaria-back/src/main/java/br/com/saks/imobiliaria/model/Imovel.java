package br.com.saks.imobiliaria.model;

import com.fasterxml.jackson.annotation.JsonIdentityInfo;
import com.fasterxml.jackson.annotation.ObjectIdGenerators;
import java.util.Date;
import java.util.List;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.JoinTable;
import javax.persistence.ManyToMany;
import javax.persistence.ManyToOne;
import javax.persistence.Temporal;
import lombok.Data;

@JsonIdentityInfo(generator = ObjectIdGenerators.PropertyGenerator.class, property = "id")
@Data
@Entity
public class Imovel {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "id_tipo_imovel")
    private TipoImovel tipoImovel;
    
    @ManyToMany
    @JoinTable(
        name = "interesse",
        joinColumns = @JoinColumn(name = "id_imovel"),
        inverseJoinColumns = @JoinColumn(name = "id_cliente")
    )
    private List<Cliente> clientes;
    
    @Column(nullable = false, length = 100)
    private String titulo;
    
    @Column(length = 500)
    private String descricao;
    
    @Column(name="data_criacao")
    @Temporal(javax.persistence.TemporalType.DATE)
    private Date dataCriacao;
    
    @Column
    private Float valor;
    
    @Column
    private Integer status;
}
