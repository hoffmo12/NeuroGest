# NeuroGest

Sistema de gestão desenvolvido para o Espaço Brincar e Aprender, instituição de
Prudentópolis voltada ao desenvolvimento infantil e ao atendimento de crianças com
transtorno do espectro autista (TEA), com equipe multidisciplinar de psicologia,
psicopedagogia, fonoaudiologia, fisioterapia e terapia ocupacional. Reúne em um só
lugar o cadastro de alunos, a agenda de consultas, o registro dos atendimentos e o
controle financeiro gerado a partir deles.

Composto por uma API em ASP.NET Core (`backend/`) e um aplicativo em Flutter
(`frontend/`), rodando sobre banco de dados MySQL.

## Funcionalidades

- Login e cadastro de usuários com autenticação por JWT
- Cadastro de alunos com cálculo automático de idade
- Calendário de agendamentos por profissional, com controle de pagamento e falta
- Registro de atendimentos clínicos, com cálculo automático de IMC
- Controle financeiro das cobranças, incluindo pagamento parcial
- Gestão de usuários e perfis de acesso (admin, profissional, recepção)

## Tecnologias

- **Back-end:** .NET 8, ASP.NET Core Web API, Entity Framework Core, MySQL (Pomelo),
  autenticação JWT, BCrypt para hash de senha
- **Front-end:** Flutter / Dart

## Configurando o ambiente de desenvolvimento

Pré-requisitos: .NET SDK 8+, MySQL 8, Flutter SDK.

### 1. Banco de dados

```bash
mysql -u root -p -e "CREATE DATABASE neurogest_db;"
```

### 2. API

```bash
cd backend
dotnet restore
```

Configure a string de conexão e a chave JWT em `appsettings.Development.json`:

```json
{
  "ConnectionStrings": {
    "Default": "Server=localhost;Port=3306;Database=neurogest_db;User=root;Password=SUA_SENHA;"
  },
  "Jwt": {
    "Chave": "uma-chave-secreta-para-desenvolvimento",
    "Issuer": "NeuroGest.API",
    "Audience": "NeuroGest.App",
    "ExpiracaoHoras": "8"
  }
}
```

### 3. App

```bash
cd frontend
flutter pub get
```

Confira o endereço da API na constante `_baseUrl` de cada arquivo em
`lib/services/`.

## Rodando localmente

```bash
# terminal 1 — API (cria as tabelas automaticamente na primeira execução)
cd backend
dotnet run

# terminal 2 — app
cd frontend
flutter run
```

Com a API em execução em ambiente de desenvolvimento, o Swagger fica disponível em
`http://localhost:5279/swagger` para testar os endpoints diretamente.

## Deploy

```bash
# API
cd backend
dotnet publish -c Release -o ./publish

# App (exemplos)
cd frontend
flutter build apk --release
flutter build web --release
```

Detalhes de configuração de produção, segurança e plano de implantação estão em
[`docs/04-manual-tecnico.md`](docs/04-manual-tecnico.md) e
[`docs/05-plano-implantacao.md`](docs/05-plano-implantacao.md).

## Documentação

| Documento | Conteúdo |
|---|---|
| [docs/01-requisitos.md](docs/01-requisitos.md) | Requisitos funcionais e não funcionais |
| [docs/02-arquitetura.md](docs/02-arquitetura.md) | Arquitetura, diagramas e decisões de design |
| [docs/03-manual-usuario.md](docs/03-manual-usuario.md) | Manual do usuário final |
| [docs/04-manual-tecnico.md](docs/04-manual-tecnico.md) | Instalação, configuração e manutenção |
| [docs/05-plano-implantacao.md](docs/05-plano-implantacao.md) | Plano de implantação em produção |

## Estrutura do repositório

```
NeuroGest/
├── backend/     API ASP.NET Core (.NET 8)
├── frontend/    App Flutter
└── docs/        Documentação do projeto
```

## Licença

Projeto de uso interno. Direitos reservados à equipe responsável.

## Créditos

Desenvolvido pela equipe do projeto NeuroGest.
