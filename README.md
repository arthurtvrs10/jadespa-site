# Jade Spa

Site, area do cliente, administracao e API Java no mesmo projeto.

## Estrutura

- frontend/: site publico, cliente/ e admin/.
- backend/: API Spring Boot com Java 21 e Maven.
- database/Dump20261115.sql: banco inicial do MySQL.
- referencias/: versao alternativa do site original.

## Executar com Docker

1. Abra o Docker Desktop e aguarde o motor iniciar.
2. Copie .env.example para .env e configure as senhas do banco e as credenciais do administrador. Se o .env local ja existe, mantenha-o.
3. Na raiz do repositorio, execute:

```powershell
docker compose up -d --build
```

Abra http://localhost:8080/ (ou a porta APP_PORT configurada). O mesmo servidor entrega o frontend e a API.

O MySQL importa o SQL somente quando o volume e criado pela primeira vez. O dump contem DROP TABLE; nao importe sobre um banco com dados que deseja preservar. O volume mantem os dados entre reinicios. Nao execute docker compose down -v se deseja preservar o banco.

Para consultar a inicializacao:

```powershell
docker compose logs --tail 80 app
```

A alternativa no Windows e executar ./Iniciar-Docker.ps1. O script cria um .env se ele nao existir.

## Login e permissoes

Todos entram em /login.cadastro.html com e-mail e senha. O backend identifica o perfil e retorna ADMIN ou CLIENTE, encaminhando automaticamente para o painel correspondente. Nao existe escolha de perfil na tela ou no cadastro publico.

O administrador e definido por ADMIN_EMAIL e ADMIN_PASSWORD no .env. Clientes usam suas contas cadastradas. O painel e as APIs administrativas exigem sessao no servidor, com expiracao apos 30 minutos sem atividade. O botao Sair invalida a sessao administrativa. Um login de cliente remove privilegios administrativos de uma sessao anterior.

O .env fica apenas na maquina e e ignorado pelo Git. Nao publique senhas no repositorio. Apos alterar as configuracoes ou o codigo, execute novamente docker compose up -d --build.

## Desenvolvimento sem Docker

Use JDK 21, MySQL e configure SPRING_DATASOURCE_URL, SPRING_DATASOURCE_USERNAME, SPRING_DATASOURCE_PASSWORD, ADMIN_EMAIL e ADMIN_PASSWORD no ambiente. Importe o banco em uma instancia destinada ao projeto. Execute:

```powershell
cd backend
./mvnw.cmd spring-boot:run
```

O Maven inclui ../frontend nos recursos static. Apos editar o frontend, reinicie a aplicacao para copiar os recursos. Nao abra os HTML diretamente por file://.

## Verificacao do login

```powershell
cd backend
./mvnw.cmd "-Dtest=AdminAccessTests,UnifiedLoginTests" test
```

Os testes verificam login de ambos os perfis, credenciais invalidas, troca de sessao, logout e bloqueio do painel e das APIs administrativas.
