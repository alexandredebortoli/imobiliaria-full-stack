package br.com.saks.imobiliaria.repository;

import br.com.saks.imobiliaria.model.Administrador;
import java.util.Optional;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface AdministradorRepository extends JpaRepository<Administrador, Long>{
    Optional<Administrador> findByEmail(String email);
}
