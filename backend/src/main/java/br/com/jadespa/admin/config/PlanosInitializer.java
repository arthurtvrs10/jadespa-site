package br.com.jadespa.admin.config;
import java.math.BigDecimal;

import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import br.com.jadespa.admin.model.Plano;
import br.com.jadespa.admin.repository.PlanoRepository;

@Component
public class PlanosInitializer implements CommandLineRunner {

    private final PlanoRepository repository;

    public PlanosInitializer(PlanoRepository repository) {
        this.repository = repository;
    }

    @Override
    @Transactional
    public void run(String... args) {
        criarSeAusente(
                "Jade Essencial",
                "299.90",
                """
                Para quem quer começar a cuidar de si.

                """.strip()
        );

        criarSeAusente(
                "Jade Equilíbrio",
                "549.90",
                """
                Para quem busca uma rotina mais completa de bem-estar.

                Encontre seu equilíbrio todos os dias.
                """.strip()
        );

        criarSeAusente(
                "Jade Premium",
                "769.90",
                """
                Para uma experiência completa de cuidado e relaxamento.

                Uma experiência completa para você.
                """.strip()
        );
    }

    private void criarSeAusente(
            String nome,
            String valor,
            String descricao
    ) {
        if (repository.findByNome(nome).isPresent()) {
            return;
        }

        Plano plano = new Plano();
        plano.setNome(nome);
        plano.setDescricao(descricao);
        plano.setValor(new BigDecimal(valor));
        plano.setAtivo(true);

        repository.save(plano);
    }
}