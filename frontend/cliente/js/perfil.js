document.addEventListener("DOMContentLoaded", async () => {
    const API_CLIENTES = "/api/clientes";
    const API_PLANOS = "/api/planos";
    const API_ASSINATURAS = "/api/assinaturas";
    const API_SOLICITACOES = "/api/solicitacoes-planos";
    const CHAVE_PERFIL = "jadeSpaPerfil";

    const form = document.getElementById("formPerfil");
    const btnEditar = document.getElementById("btnEditar");
    const btnCancelar = document.getElementById("btnCancelar");
    const acoes = document.getElementById("acoes");
    const mensagem = document.getElementById("mensagem");

    const campos = {
        nome: document.getElementById("nome"),
        email: document.getElementById("email"),
        telefone: document.getElementById("telefone"),
        nascimento: document.getElementById("nascimento")
    };

    const avatarGrande = document.querySelector(".avatar-grande");
    const avatarMini = document.querySelector(".avatar-mini");

    const nomePlanoAtual = document.getElementById("nomePlanoAtual");
    const descricaoPlanoAtual = document.getElementById("descricaoPlanoAtual");
    const valorPlanoAtual = document.getElementById("valorPlanoAtual");
    const statusPlanoAtual = document.getElementById("statusPlanoAtual");
    const mensagemPlano = document.getElementById("mensagemPlano");
    const listaPlanos = document.getElementById("listaPlanos");

    let dadosOriginais = {};
    let idCliente = null;
    let solicitandoPlano = false;

    function escrever(elemento, texto) {
        if (elemento) elemento.textContent = texto;
    }

    function mostrarMensagemPlano(texto) {
        escrever(mensagemPlano, texto);
    }

    // ===== REQUISIÇÕES =====

    async function requisitar(url, opcoes = {}) {
        const resposta = await fetch(url, {
            ...opcoes,
            credentials: "same-origin",
            headers: {
                Accept: "application/json",
                ...opcoes.headers
            }
        });

        const texto = await resposta.text();
        let dados = null;

        if (texto) {
            try {
                dados = JSON.parse(texto);
            } catch {
                dados = null;
            }
        }

        if (!resposta.ok) {
            const erro = new Error(
                dados?.detail ||
                dados?.message ||
                dados?.mensagem ||
                `Não foi possível concluir a operação. Código: ${resposta.status}`
            );

            erro.status = resposta.status;
            throw erro;
        }

        return dados;
    }

    // ===== SESSÃO E AVATARES =====

    function obterSessao() {
        try {
            return JSON.parse(localStorage.getItem(CHAVE_PERFIL));
        } catch (erro) {
            console.error("Erro ao recuperar sessão:", erro);
            return null;
        }
    }

    function obterIniciais(nome) {
        const partes = (nome || "")
            .trim()
            .split(/\s+/)
            .filter(Boolean);

        if (!partes.length) return "?";
        if (partes.length === 1) {
            return partes[0].charAt(0).toUpperCase();
        }

        return (
            partes[0].charAt(0) +
            partes[partes.length - 1].charAt(0)
        ).toUpperCase();
    }

    function atualizarAvatares(nome) {
        const iniciais = obterIniciais(nome);
        escrever(avatarGrande, iniciais);
        escrever(avatarMini, iniciais);
    }

    // ===== DADOS PESSOAIS =====

    function preencherFormulario(dados) {
        if (campos.nome) campos.nome.value = dados.nome || "";
        if (campos.email) campos.email.value = dados.email || "";
        if (campos.telefone) campos.telefone.value = dados.telefone || "";

        if (campos.nascimento) {
            campos.nascimento.value = dados.dataNascimento || "";
        }

        atualizarAvatares(dados.nome);
    }

    function definirEdicao(permitirEditar) {
        Object.values(campos).forEach(campo => {
            if (campo) campo.disabled = !permitirEditar;
        });

        if (btnEditar) btnEditar.hidden = permitirEditar;
        if (acoes) acoes.hidden = !permitirEditar;

        escrever(mensagem, "");
    }

    function capturarDados() {
        return {
            nome: campos.nome?.value.trim() || "",
            email: campos.email?.value.trim() || "",
            telefone: campos.telefone?.value.trim() || "",
            dataNascimento: campos.nascimento?.value || null
        };
    }

    async function carregarPerfil() {
        const sessao = obterSessao();

        if (!sessao?.id) {
            escrever(
                mensagem,
                "Não foi possível identificar sua conta. Faça login novamente."
            );

            if (form) form.hidden = true;
            return false;
        }

        idCliente = sessao.id;

        try {
            const dados = await requisitar(
                `${API_CLIENTES}/${idCliente}`,
                { cache: "no-store" }
            );

            if (!dados) {
                throw new Error("O servidor não retornou os dados do perfil.");
            }

            preencherFormulario(dados);

            dadosOriginais = {
                nome: dados.nome || "",
                email: dados.email || "",
                telefone: dados.telefone || "",
                dataNascimento: dados.dataNascimento || null
            };

            localStorage.setItem(
                CHAVE_PERFIL,
                JSON.stringify({ ...sessao, ...dados })
            );

            return true;
        } catch (erro) {
            console.error("Erro ao carregar perfil:", erro);
            escrever(mensagem, erro.message);
            return false;
        }
    }

    btnEditar?.addEventListener("click", () => {
        dadosOriginais = capturarDados();
        definirEdicao(true);
        campos.nome?.focus();
    });

    btnCancelar?.addEventListener("click", () => {
        preencherFormulario(dadosOriginais);
        definirEdicao(false);
        escrever(mensagem, "Alterações canceladas.");
    });

    form?.addEventListener("submit", async evento => {
        evento.preventDefault();

        if (!form.checkValidity()) {
            form.reportValidity();
            return;
        }

        const novosDados = capturarDados();

        if (!novosDados.nome || !novosDados.email) {
            escrever(mensagem, "Preencha seu nome e e-mail.");
            return;
        }

        try {
            await requisitar(`${API_CLIENTES}/${idCliente}`, {
                method: "PUT",
                headers: { "Content-Type": "application/json" },
                body: JSON.stringify(novosDados)
            });

            const sessao = obterSessao() || {};

            localStorage.setItem(
                CHAVE_PERFIL,
                JSON.stringify({ ...sessao, ...novosDados })
            );

            preencherFormulario(novosDados);
            dadosOriginais = { ...novosDados };
            definirEdicao(false);

            escrever(mensagem, "Perfil atualizado com sucesso!");
        } catch (erro) {
            console.error("Erro ao atualizar perfil:", erro);
            escrever(mensagem, erro.message);
        }
    });

    // ===== PLANO ATUAL =====

    function formatarMoeda(valor) {
        return Number(valor).toLocaleString("pt-BR", {
            style: "currency",
            currency: "BRL"
        });
    }

    async function carregarPlanoAtual() {
        try {
            const dados = await requisitar(
                `${API_ASSINATURAS}/cliente/${idCliente}/ativa`,
                { cache: "no-store" }
            );

            if (!dados) {
                throw new Error("O servidor não retornou a assinatura.");
            }

            if (!dados.temPlano) {
                escrever(nomePlanoAtual, "Nenhum plano ativo");
                escrever(
                    descricaoPlanoAtual,
                    "Você ainda não possui uma assinatura."
                );
                escrever(valorPlanoAtual, "--");
                escrever(statusPlanoAtual, "Sem plano");
                return;
            }

            escrever(nomePlanoAtual, dados.plano.nome);
            escrever(descricaoPlanoAtual, dados.plano.descricao || "");
            escrever(valorPlanoAtual, formatarMoeda(dados.plano.valor));
            escrever(statusPlanoAtual, dados.status);
        } catch (erro) {
            console.error("Erro ao carregar plano atual:", erro);
            escrever(nomePlanoAtual, "Não foi possível carregar");
            escrever(descricaoPlanoAtual, "Tente atualizar a página.");
            escrever(valorPlanoAtual, "--");
            escrever(statusPlanoAtual, "Indisponível");
        }
    }

    // ===== SOLICITAÇÃO PERSISTIDA NO BANCO =====

    async function recuperarSolicitacaoPendente() {
        const solicitacoes = await requisitar(
            `${API_SOLICITACOES}/cliente/${idCliente}`,
            { cache: "no-store" }
        );

        if (!Array.isArray(solicitacoes)) {
            throw new Error("O servidor retornou uma lista de solicitações inválida.");
        }

        // Prioriza pedidos já enviados para análise.
        const pendente =
            solicitacoes.find(s => s.status === "AGUARDANDO_ANALISE") ||
            solicitacoes.find(s => s.status === "AGUARDANDO_COMPROVANTE");

        document.getElementById("btnRetomarPlano")?.remove();

        if (!pendente) {
            mostrarMensagemPlano("");
            return null;
        }

        if (!pendente.plano || !pendente.id) {
            throw new Error("A solicitação salva está com dados incompletos.");
        }

        if (pendente.status === "AGUARDANDO_ANALISE") {
            mostrarMensagemPlano(
                `Plano escolhido: ${pendente.plano.nome}. ` +
                "Aguardando aprovação do administrador."
            );
        } else {
            mostrarMensagemPlano(
                `Plano escolhido: ${pendente.plano.nome}. ` +
                "Pagamento demonstrativo pendente."
            );

            const retomar = document.createElement("button");
            retomar.id = "btnRetomarPlano";
            retomar.type = "button";
            retomar.className = "btn-principal";
            retomar.textContent = "Continuar pagamento";

            retomar.addEventListener("click", () => {
                criarJanelaPix(pendente.plano, pendente.id);
            });

            mensagemPlano?.insertAdjacentElement("afterend", retomar);
        }

        return pendente;
    }

    // ===== PAGAMENTO DEMONSTRATIVO =====

    function criarJanelaPix(plano, solicitacaoId) {
        document.getElementById("modalPixJade")?.remove();

        const overlay = document.createElement("div");
        overlay.id = "modalPixJade";

        Object.assign(overlay.style, {
            position: "fixed",
            inset: "0",
            background: "rgba(0,0,0,0.55)",
            zIndex: "9999",
            display: "flex",
            alignItems: "center",
            justifyContent: "center",
            padding: "20px",
            overflowY: "auto"
        });

        const modal = document.createElement("div");
        modal.setAttribute("role", "dialog");
        modal.setAttribute("aria-modal", "true");
        modal.setAttribute("aria-labelledby", "tituloPixJade");

        Object.assign(modal.style, {
            background: "#ffffff",
            width: "100%",
            maxWidth: "430px",
            maxHeight: "90vh",
            overflowY: "auto",
            boxSizing: "border-box",
            padding: "28px",
            borderRadius: "16px",
            textAlign: "center",
            color: "#294936",
            fontFamily: "Inter, Arial, sans-serif",
            boxShadow: "0 10px 35px rgba(0,0,0,0.2)"
        });

        const titulo = document.createElement("h2");
        titulo.id = "tituloPixJade";
        titulo.textContent = "Pagamento Pix";

        const aviso = document.createElement("p");
        aviso.textContent =
            "AMBIENTE DE DEMONSTRAÇÃO — PAGAMENTO NÃO REAL";

        Object.assign(aviso.style, {
            background: "#fff3cd",
            color: "#856404",
            padding: "10px",
            borderRadius: "8px",
            fontSize: "12px",
            fontWeight: "bold"
        });

        const nome = document.createElement("h3");
        nome.textContent = plano.nome;

        const valor = document.createElement("h2");
        valor.textContent = `${formatarMoeda(plano.valor)} / mês`;

        const qr = document.createElement("div");
        qr.textContent = "PIX DE TESTE";

        Object.assign(qr.style, {
            width: "160px",
            height: "160px",
            margin: "20px auto",
            border: "2px dashed #294936",
            borderRadius: "10px",
            display: "flex",
            alignItems: "center",
            justifyContent: "center",
            padding: "15px",
            boxSizing: "border-box",
            fontWeight: "bold",
            fontSize: "14px"
        });

        const explicacao = document.createElement("p");
        explicacao.textContent =
            "Este código é apenas ilustrativo e não pode ser " +
            "escaneado para realizar uma transferência.";

        Object.assign(explicacao.style, {
            fontSize: "13px",
            color: "#666"
        });

        const identificacao = document.createElement("p");
        identificacao.textContent = `Solicitação nº ${solicitacaoId}`;

        const botaoPagar = document.createElement("button");
        botaoPagar.type = "button";
        botaoPagar.textContent = "Simular pagamento";

        Object.assign(botaoPagar.style, {
            width: "100%",
            padding: "13px",
            background: "#294936",
            color: "#ffffff",
            border: "none",
            borderRadius: "8px",
            cursor: "pointer",
            fontSize: "15px",
            marginTop: "15px"
        });

        const botaoFechar = document.createElement("button");
        botaoFechar.type = "button";
        botaoFechar.textContent = "Fechar";

        Object.assign(botaoFechar.style, {
            width: "100%",
            padding: "12px",
            background: "#eeeeee",
            color: "#333333",
            border: "none",
            borderRadius: "8px",
            cursor: "pointer",
            marginTop: "10px"
        });

        const resultado = document.createElement("p");
        resultado.setAttribute("role", "status");

        botaoFechar.addEventListener("click", () => overlay.remove());

        botaoPagar.addEventListener("click", async () => {
            if (botaoPagar.disabled) return;

            botaoPagar.disabled = true;
            botaoPagar.textContent = "Processando simulação...";

            try {
                await requisitar(
                    `${API_SOLICITACOES}/${solicitacaoId}/pix-simulado`,
                    { method: "POST" }
                );
            } catch (erro) {
                console.error("Erro no pagamento demonstrativo:", erro);
                resultado.textContent = erro.message;
                resultado.style.color = "#b42318";
                botaoPagar.disabled = false;
                botaoPagar.textContent = "Tentar novamente";
                return;
            }

            resultado.textContent =
                "Pagamento demonstrativo registrado! " +
                "Aguarde a aprovação do administrador.";

            resultado.style.color = "#294936";
            resultado.style.fontWeight = "bold";
            botaoPagar.textContent = "Pagamento simulado";

            document.getElementById("btnRetomarPlano")?.remove();

            mostrarMensagemPlano(
                `Plano escolhido: ${plano.nome}. ` +
                "Aguardando aprovação do administrador."
            );

            // Uma falha na atualização da tela não permite repetir o pagamento.
            try {
                await recuperarSolicitacaoPendente();
            } catch (erro) {
                console.error("Erro ao atualizar solicitação:", erro);
            }
        });

        modal.append(
            titulo,
            aviso,
            nome,
            valor,
            qr,
            explicacao,
            identificacao,
            botaoPagar,
            resultado,
            botaoFechar
        );

        overlay.appendChild(modal);
        document.body.appendChild(overlay);
        botaoPagar.focus();
    }

    // ===== ESCOLHER PLANO =====

    async function escolherPlano(plano) {
        if (solicitandoPlano) return;

        if (!idCliente) {
            alert("Faça login novamente para escolher um plano.");
            return;
        }

        solicitandoPlano = true;

        const botoes = listaPlanos
            ? [...listaPlanos.querySelectorAll("button")]
            : [];

        botoes.forEach(botao => {
            botao.disabled = true;
        });

        try {
            mostrarMensagemPlano("Consultando sua solicitação...");

            const pendente = await recuperarSolicitacaoPendente();

            if (pendente?.status === "AGUARDANDO_ANALISE") {
                alert(
                    `Seu pedido do plano ${pendente.plano.nome} ` +
                    "já está aguardando aprovação do administrador."
                );
                return;
            }

            if (
                pendente &&
                Number(pendente.plano.id) === Number(plano.id)
            ) {
                criarJanelaPix(pendente.plano, pendente.id);
                return;
            }

            const confirmou = window.confirm(
                `Deseja solicitar o plano ${plano.nome} por ` +
                `${formatarMoeda(plano.valor)} por mês?`
            );

            if (!confirmou) return;

            mostrarMensagemPlano("Salvando sua escolha...");

            let dados;

            try {
                dados = await requisitar(
                    `${API_SOLICITACOES}/cliente/${idCliente}/plano/${plano.id}`,
                    { method: "POST" }
                );
            } catch (erro) {
                if (erro.status === 409) {
                    const existente = await recuperarSolicitacaoPendente();

                    if (existente) {
                        alert(mensagemPlano?.textContent || erro.message);
                        return;
                    }
                }

                throw erro;
            }

            if (!dados?.id) {
                throw new Error("O servidor não retornou a solicitação.");
            }

            // A escolha já está salva, mesmo se a atualização visual falhar.
            try {
                await recuperarSolicitacaoPendente();
            } catch (erro) {
                console.error("Erro ao atualizar solicitação:", erro);
                mostrarMensagemPlano(
                    `Plano escolhido: ${plano.nome}. Pagamento pendente.`
                );
            }

            criarJanelaPix(dados.plano || plano, dados.id);
        } catch (erro) {
            console.error("Erro ao escolher plano:", erro);
            mostrarMensagemPlano(erro.message);
            alert(erro.message);
        } finally {
            solicitandoPlano = false;

            botoes.forEach(botao => {
                botao.disabled = false;
            });
        }
    }

    // ===== LISTAR PLANOS =====

    async function carregarPlanos() {
        if (!listaPlanos) return;

        listaPlanos.textContent = "Carregando planos...";

        try {
            const planos = await requisitar(API_PLANOS, {
                cache: "no-store"
            });

            if (!Array.isArray(planos)) {
                throw new Error("O servidor retornou uma lista de planos inválida.");
            }

            listaPlanos.replaceChildren();

            if (!planos.length) {
                listaPlanos.textContent =
                    "Não existem planos disponíveis no momento.";
                return;
            }

            planos.forEach(plano => {
                const card = document.createElement("div");
                card.className = "item-conta plano-card";

                const informacoes = document.createElement("div");

                const titulo = document.createElement("h3");
                titulo.textContent = plano.nome;

                const descricao = document.createElement("p");
                descricao.textContent = plano.descricao || "";
                descricao.style.whiteSpace = "pre-line";

                const valor = document.createElement("p");
                valor.textContent = `${formatarMoeda(plano.valor)} / mês`;

                const botao = document.createElement("button");
                botao.type = "button";
                botao.textContent = "Escolher plano";
                botao.className = "btn-principal";

                botao.addEventListener("click", () => {
                    escolherPlano(plano);
                });

                informacoes.append(titulo, descricao, valor);
                card.append(informacoes, botao);
                listaPlanos.appendChild(card);
            });
        } catch (erro) {
            console.error("Erro ao carregar planos:", erro);
            listaPlanos.textContent = erro.message;
        }
    }

    // ===== CONTRATO =====

    const btnContrato = document.getElementById("btnContrato");
    const detalhesContrato = document.getElementById("detalhesContrato");

    if (btnContrato && detalhesContrato) {
        btnContrato.addEventListener("click", () => {
            const estaAberto = !detalhesContrato.hidden;

            detalhesContrato.hidden = estaAberto;
            btnContrato.textContent = estaAberto
                ? "Ver contrato"
                : "Ocultar contrato";
        });
    }

    // ===== ENCERRAR SESSÃO =====

    const btnSair = document.getElementById("btnSair");

    btnSair?.addEventListener("click", () => {
        if (!window.confirm("Deseja realmente encerrar sua sessão?")) {
            return;
        }

        sessionStorage.clear();
        localStorage.removeItem(CHAVE_PERFIL);
        window.location.href = "../login.cadastro.html";
    });

    // ===== INICIALIZAÇÃO =====

    const perfilCarregado = await carregarPerfil();

    if (perfilCarregado) {
        await Promise.all([
            carregarPlanoAtual(),
            carregarPlanos()
        ]);

        try {
            await recuperarSolicitacaoPendente();
        } catch (erro) {
            console.error("Erro ao recuperar solicitação:", erro);
            mostrarMensagemPlano(erro.message);
        }
    }
});