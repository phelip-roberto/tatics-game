# Tatics Game

Protótipo de RPG tático single-player em Godot 4, desenvolvido em GDScript para PC. O projeto começa com uma batalha tática em grid hexagonal flat-top; a arte geométrica atual é provisória.

## Requisitos

- Godot 4.7 ou compatível com a versão indicada em `project.godot`.

## Executar

1. Abra o Godot Project Manager.
2. Selecione **Import** e escolha o arquivo `project.godot` nesta pasta.
3. Abra o projeto e pressione **F6** para executar a cena atual ou **F5** para executar a cena principal.

## Estrutura

```text
assets/       Recursos visuais e de áudio
resources/    Recursos reutilizáveis do Godot
scenes/       Cenas do jogo
scripts/      Lógica GDScript
ui/           Interface
AGENTS.md     Convenções e contexto para desenvolvimento assistido
BACKLOG.md    Resumo do backlog do produto
Backlog_Tecnico_RPG_Tatico_v2_0.md  Especificação detalhada dos tickets
```

## Estado do protótipo

O projeto contém uma cena de batalha com grid hexagonal, uma unidade placeholder, seleção e movimentação direta por alcance. Pathfinding, prévia/confirmação/cancelamento de movimento, turnos e combate ainda estão por implementar. Consulte os backlogs antes de iniciar um ticket.

## Convenção de commits

As mensagens seguem [Conventional Commits](https://www.conventionalcommits.org/), no formato:

```text
<tipo>(<escopo>): <descrição no imperativo, em inglês>
```

Tipos comuns: `feat` para funcionalidade, `fix` para correção, `refactor` para mudança estrutural, `docs` para documentação, `test` para testes e `chore` para manutenção. Exemplo: `chore(repo): add project setup documentation`.

## Escopo

O jogo é single-player. Multiplayer, backend, progressão persistente e migração para 3D estão fora do escopo atual.
