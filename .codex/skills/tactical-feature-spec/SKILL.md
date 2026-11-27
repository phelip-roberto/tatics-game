---
name: tactical-feature-spec
description: Use quando for solicitada uma nova mecânica tática complexa, antes de gerar código.
---

# Tactical Feature Spec

Antes de gerar código para uma mecânica tática complexa:

1. Apresente um plano curto separando lógica de simulação e camada visual.
2. Defina os contratos envolvidos: `Resource`, `Command` e `signals`.
3. Liste casos de borda táticos, incluindo alvos inválidos, alcance, bloqueios e limites de ações/recursos pertinentes.
4. Descreva o plano de testes nativos da Godot.
5. Aguarde confirmação do usuário antes de implementar.

Não peça confirmação para tarefas simples de manutenção ou correções locais que não introduzam mecânica complexa.
