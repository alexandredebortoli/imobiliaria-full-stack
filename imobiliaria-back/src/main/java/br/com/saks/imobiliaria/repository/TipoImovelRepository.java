package br.com.saks.imobiliaria.repository;

import br.com.saks.imobiliaria.model.TipoImovel;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface TipoImovelRepository extends JpaRepository<TipoImovel, Long>{
}
