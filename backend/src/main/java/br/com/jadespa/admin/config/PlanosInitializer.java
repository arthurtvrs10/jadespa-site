package br.com.jadespa.admin.config;
import br.com.jadespa.admin.model.Plano;
import br.com.jadespa.admin.repository.PlanoRepository;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;

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

                ✓ 1 Massagem Relaxante por mês
                ✓ 1 Sessão de Meditação por mês
                ✓ Acesso às Aulas Complementares

                Comece sua jornada de bem-estar.
                """.strip()
        );

        criarSeAusente(
                "Jade Equilíbrio",
                "549.90",
                """
                Para quem busca uma rotina mais completa de bem-estar.

                ✓ 2 Massagens Relaxantes por mês
                ✓ 1 Tratamento Facial por mês
                ✓ 2 Sessões de Meditação por mês
                ✓ Acesso às Aulas Complementares
                ✓ Avaliação de bem-estar

                Encontre seu equilíbrio todos os dias.
                """.strip()
        );

        criarSeAusente(
                "Jade Premium",
                "769.90",
                """
                Para uma experiência completa de cuidado e relaxamento.

                ✓ 4 Massagens Relaxantes por mês
                ✓ 2 Tratamentos Faciais por mês
                ✓ 1 Banho de Ofurô por mês
                ✓ 2 Sessões de Meditação por mês
                ✓ Acesso às Aulas Complementares
                ✓ Avaliação personalizada de bem-estar

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