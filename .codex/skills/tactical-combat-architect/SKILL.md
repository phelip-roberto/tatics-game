---
name: tactical-combat-architect
description: Use ao criar ou alterar turnos, iniciativa, ações de combate, status ou recursos táticos.
---

# Tactical Combat Architect

- Modele cada ação de combate como Command: `RefCounted` com `execute()` e `undo()` explícitos.
- Modele as fases e transições da batalha com uma máquina de estados finitos (FSM) explícita; rejeite transições inválidas.
- Armazene dados de unidades, habilidades e efeitos em `Resource` customizados com `class_name` e propriedades `@export` tipadas.
- Desacople sistemas e apresentação com `signals`; evite dependências diretas desnecessárias entre nós.
- Mantenha resolução de combate determinística e lógica independente da camada visual.
- Considere limites de recursos, ações indisponíveis, alvos inválidos, incapacitação e desfazer quando aplicável.
