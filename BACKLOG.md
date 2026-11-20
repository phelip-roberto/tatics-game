# Backlog do Produto — RPG Tático Isométrico

**Produto:** RPG Tático Single-player  
**Plataforma:** PC / Steam  
**Engine:** Godot 4  
**Linguagem:** GDScript  
**Documento-base:** GDD v0.2 + AGENTS.md  
**Status:** Backlog inicial para aprovação do PO

## Objetivo do MVP

Entregar uma batalha tática completa, reiniciável, com três aliados predefinidos, inimigos controlados por IA, movimentação hexagonal, turnos, habilidades, HP, mana, incapacitação, reviver e condições de vitória e derrota.

## Priorização

- **P0:** Fundação e movimentação.
- **P1:** Sistemas essenciais do combate.
- **P2:** Interface e apresentação.
- **P3:** Validação final.
- **DEC:** Decisões de produto pendentes.

## Épicos

1. Fundação e arquitetura.
2. Tabuleiro e movimentação.
3. Sistema de turnos e ações.
4. Personagens e atributos.
5. Habilidades e combate.
6. Inimigos e inteligência artificial.
7. Interface e experiência.
8. Câmera, arte e apresentação.
9. Testes e validação.

## Critério de conclusão do MVP

O MVP estará concluído quando:

- A batalha iniciar com três aliados e inimigos.
- A iniciativa for definida e mantida.
- O jogador conseguir selecionar e movimentar unidades.
- Movimento tiver prévia, confirmação e cancelamento.
- As ações respeitarem os limites por turno.
- Habilidades respeitarem mana, alcance e regras de alvo.
- Dano, cura, incapacitação e reviver funcionarem corretamente.
- A IA conseguir movimentar e atacar.
- Vitória e derrota forem reconhecidas corretamente.
- A tela final permitir reiniciar a batalha.
- Os principais sistemas tiverem testes reproduzíveis.
- O projeto gerar uma build executável.

## Regras de gestão do backlog

1. Nenhum ticket deve ser considerado concluído sem atender aos critérios de aceite.
2. O Codex deve analisar o código existente antes de implementar.
3. Toda alteração deve ser pequena e validável.
4. Decisões pendentes não podem ser assumidas pelo desenvolvedor ou pelo Codex.
5. Regras de gameplay devem permanecer separadas da apresentação.
6. Novos sistemas só devem entrar no escopo mediante aprovação do PO.
7. A cada entrega, validar o resultado no Godot.
8. Manter o projeto executável durante todo o desenvolvimento.

## Fora do MVP

- Multiplayer.
- Backend de jogo.
- Campanha narrativa.
- Progressão persistente.
- XP e níveis.
- Equipamentos persistentes.
- Save entre sessões.
- Grande catálogo de personagens e inimigos.
- Dificuldade selecionável.
