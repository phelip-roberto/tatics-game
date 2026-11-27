---
name: godot-native-qa
description: Use após implementar mecânicas ou corrigir bugs para validar o projeto e criar testes nativos da Godot.
---

# Godot Native QA

- Valide o projeto pela CLI com `godot --headless --quit`.
- Crie testes unitários nativos em `res://tests/test_<sistema>.gd`, herdando de `SceneTree`.
- Em cada teste, use `assert()` no `_init()` e finalize com `quit(0)` quando as verificações passarem.
- Execute cada arquivo com `godot --headless -s res://tests/test_<sistema>.gd`.
- Cubra comportamento normal, limites e casos inválidos relevantes; reporte o comando e o resultado.
