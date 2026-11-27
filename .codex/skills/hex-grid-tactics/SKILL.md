---
name: hex-grid-tactics
description: Use ao trabalhar com grid hexagonal, alcance, AoE, linha de visão, pathfinding ou conversão isométrica.
---

# Hex Grid Tactics

- Represente lógica de células com coordenadas axiais `Vector2i(q, r)` ou cúbicas `Vector3i(q, r, s)`, garantindo `q + r + s == 0` no modelo cúbico.
- Implemente a lista explícita de seis vizinhos para hexágonos flat-top; não use vizinhança ortogonal/quadrada.
- Faça busca de caminho em grafo lógico com `AStar2D` ou coordenadas hexagonais. Não use colisores físicos para pathfinding.
- Mantenha conversões entre coordenadas hexagonais e posições isométricas em funções explícitas e testáveis.
- Na camada visual que organiza unidades por profundidade, configure `y_sort_enabled = true`.
- Valide distância, vizinhos, conversão e caminhos com casos de borda hexagonais.
