# Backlog Técnico — RPG Tático Isométrico

**Versão 2.0 · 11 de novembro de 2026**

RPG Tático Isométrico — Godot 4

Versão 2.0 • 11 de novembro de 2026

Documento de produto e implementação para orientar a construção incremental do protótipo jogável. Cada ticket contém descrição, objetivo técnico, abordagem de implementação, critérios de aceite, validação e dependências.

## 1. Visão e objetivo do MVP

Construir uma batalha tática single-player completa e reiniciável para PC/Steam, em Godot 4 com GDScript. O MVP final terá três aliados predefinidos contra três inimigos. A implementação será incremental: primeiro 1v1, depois 2v2 e, por fim, 3v3. O foco inicial é validar o combate; arte final e integração de assets ficam para depois.

- Tabuleiro plano de aproximadamente 12 × 12 células hexagonais flat-top, sem elevação.

- Separação entre coordenadas lógicas, coordenadas visuais e ocupação das células.

- Movimento por unidade: cada célula custa 1; inimigos bloqueiam passagem; aliados podem ser atravessados, mas não podem ser destino.

- Pré-visualização de movimento com confirmação/cancelamento; cancelar não consome ação.

- Uma ação de movimento e uma ação principal por turno, em qualquer ordem.

- Iniciativa fixa durante a batalha: Velocidade e depois Inteligência.

- Aliados com 0 HP ficam incapacitados e liberam célula; inimigos com 0 HP são removidos permanentemente.

- Ressurreição: aliado retorna com 1 HP na célula livre mais próxima do conjurador e só age no próximo turno próprio.

- Vitória quando todos os inimigos forem derrotados; derrota quando todos os aliados estiverem incapacitados; simultaneidade resulta em derrota.

- IA simples: aproximar-se e atacar aliados próximos, com seleção considerando proximidade, vulnerabilidade e ameaça.

## 2. Decisões de produto e limites

| Tema | Decisão / estado |
| --- | --- |
| Escopo final | Uma batalha completa e reiniciável; 3 aliados contra 3 inimigos. |
| Evolução | Desenvolver 1v1 → 2v2 → 3v3. |
| Visual | Placeholders até o combate estar funcional; assets finais depois. |
| Progressão | Sem campanha, XP, equipamentos, saves persistentes ou progressão entre batalhas. |
| Tabuleiro | Hexagonal flat-top, plano, sem elevação. Obstáculos/LOS ficam para etapa posterior. |
| Tecnologia | Godot 4 / GDScript; não migrar para 3D sem decisão explícita. |
| Pendências | Ataque básico; desempate de iniciativa; arredondamento/timing da mana; targeting/LOS; duração/stacking de efeitos; dados finais de personagens. |

## 3. Regras de trabalho técnico

- Inspecionar o repositório antes de alterar código; confirmar arquivos, nós, scripts e comportamento real. Caminhos propostos não significam que arquivos futuros já existam.

- Preservar seleção e movimentação já validadas durante refatorações; trabalhar em mudanças pequenas.

- Separar lógica de domínio, coordenação, geometria, renderização e apresentação. O desenho não é fonte da verdade das regras.

- Usar coordenadas hexagonais lógicas para regras/ocupação; converter para local/global apenas na fronteira visual.

- Usar GDScript tipado quando útil, snake_case, PascalCase para classes, evitar números mágicos e autoloads desnecessários.

- Preferir sinais para reduzir acoplamento; validar caminhos de nós e transformações local/global.

- Não decidir regras pendentes por suposição. Registrar bloqueio e pedir decisão do PO.

- Na entrega, listar arquivos alterados, decisões, testes executados, resultados e limitações.

## 4. Arquitetura-alvo evolutiva

Estrutura proposta, sujeita à inspeção e ajustes justificados:

- scenes/battle/battle.tscn — composição da cena principal.

- scenes/units/unit.tscn — representação instanciável de unidade.

- scripts/battle/battle.gd — inicialização/composição da batalha.

- scripts/battle/battle_controller.gd — coordenação de interação e fluxo.

- scripts/grid/hex_grid.gd — geometria, conversão e desenho.

- scripts/grid/pathfinder.gd — caminhos e células alcançáveis, sem desenhar.

- scripts/units/unit.gd — estado/dados e representação básica da unidade.

- Componentes futuros (BattleState, TurnManager, AbilityData, CombatResolver etc.) devem ser criados quando os tickets exigirem.

Cena-alvo: Battle (Node2D) com HexGrid (Node2D), Units (Node2D) e BattleController (Node). A unidade de teste atualmente filha de HexGrid só deve migrar para Units quando a conversão HexGrid local → global → Units local estiver validada. Não corrigir alinhamento com offsets arbitrários.

## 5. Priorização e estimativas

Prioridade: P0 = bloqueia núcleo; P1 = necessário para fechar MVP; P2 = pode vir após loop principal. Tamanho: P/P/M/G = pequeno/médio/grande relativo ao projeto, não horas. Marcos M0–M9 indicam sequência sugerida.

Sequência recomendada: fundação → grid/movimento → combate 1v1 → turnos/ações → resolução de combate/estados → IA → validação 1v1 → expansão 2v2 → expansão 3v3 → apresentação.

## 6. Tickets técnicos

### RPG-001 — Configurar Git e convenções

Fundação  |  Prioridade P0  |  Tamanho P  |  Marco M0

**Descrição:** Versionar projeto Godot e documentar execução/convenções.

**Especificação técnica / arquivos:** Inspecionar projeto; criar .gitignore e README; preservar AGENTS.md existente. Não versionar cache, builds ou segredos.

**Critérios de aceite:** Repositório abre em Godot 4; instruções de execução documentadas; arquivos-fonte versionados.

**Testes e validação:** Abrir projeto limpo e executar cena principal.

**Dependências:** Nenhuma.

### RPG-002 — Definir estratégia mínima de testes

Fundação  |  Prioridade P1  |  Tamanho M  |  Marco M0

**Descrição:** Estabelecer testes repetíveis para lógica do jogo.

**Especificação técnica / arquivos:** Inspecionar versão Godot; escolher testes GDScript/headless ou framework somente se necessário; documentar comando e estrutura.

**Critérios de aceite:** Ao menos um teste simples passa e o procedimento está documentado.

**Testes e validação:** Executar testes no editor/headless, se suportado.

**Dependências:** 001.

### RPG-003 — Organizar cena principal da batalha

Fundação  |  Prioridade P0  |  Tamanho M  |  Marco M0

**Descrição:** Separar grid, unidades e coordenação sem quebrar seleção/movimento existentes.

**Especificação técnica / arquivos:** Inspecionar battle.tscn, battle.gd, hex_grid.gd e unit.gd. Estrutura-alvo Battle → HexGrid, Units, BattleController. Migrar unidade de teste somente após validar transforms.

**Critérios de aceite:** Cena abre; grid centralizado; unidade continua alinhada, selecionável e móvel.

**Testes e validação:** Executar cena e conferir posição após escala/centralização.

**Dependências:** 001.

### RPG-004 — Criar coordenador da batalha

Fundação  |  Prioridade P0  |  Tamanho M  |  Marco M0

**Descrição:** Criar ponto de coordenação do fluxo da batalha.

**Especificação técnica / arquivos:** Criar battle_controller.gd no nó BattleController; battle.gd inicializa/compoõe; controller coordena entrada e sistemas por interfaces/sinais.

**Critérios de aceite:** Responsabilidades separadas; inicialização ocorre uma vez; sem referências nulas.

**Testes e validação:** Executar cena e verificar inicialização.

**Dependências:** 003.

### RPG-005 — Centralizar validação de ações

Fundação  |  Prioridade P0  |  Tamanho G  |  Marco M1

**Descrição:** Evitar regras diferentes entre jogador, UI e IA.

**Especificação técnica / arquivos:** Criar action_validator ou componente equivalente; validar ator, ação, alvo/destino e estado sem efeitos colaterais; retornar motivo estruturado.

**Critérios de aceite:** Jogador e IA usam a mesma validação; falhas não alteram estado.

**Testes e validação:** Testar ações válidas/inválidas sem consumo de recursos.

**Dependências:** 004.

### RPG-006 — Modelo lógico do tabuleiro hexagonal

Grid  |  Prioridade P0  |  Tamanho M  |  Marco M0

**Descrição:** Representar tabuleiro 12×12 em coordenadas lógicas.

**Especificação técnica / arquivos:** Criar HexBoard ou estender componente de grid; dimensões e limites independentes de pixels/desenho.

**Critérios de aceite:** Consultar células e limites sem renderização.

**Testes e validação:** Testar centro, bordas e cantos.

**Dependências:** 001, 002.

### RPG-007 — Vizinhança hexagonal

Grid  |  Prioridade P0  |  Tamanho P  |  Marco M0

**Descrição:** Fornecer seis vizinhos de cada célula na convenção flat-top escolhida.

**Especificação técnica / arquivos:** Documentar convenção de coordenadas; implementar vizinhos e filtrar fora do tabuleiro.

**Critérios de aceite:** Célula interior tem seis vizinhos únicos; bordas só retornam válidos.

**Testes e validação:** Testar centro, cantos e simetria.

**Dependências:** 006.

### RPG-008 — Conversão lógica/visual

Grid  |  Prioridade P0  |  Tamanho M  |  Marco M0

**Descrição:** Separar célula lógica, coordenada local e posição global.

**Especificação técnica / arquivos:** Centralizar cell_to_local e conversão de mouse/célula; ao usar Units como irmão de HexGrid, converter HexGrid local→global→Units local.

**Critérios de aceite:** Unidades coincidem com centros mesmo com grid escalado/centralizado; sem offsets arbitrários.

**Testes e validação:** Testar canto/centro, transforms e picking.

**Dependências:** 003, 006.

### RPG-009 — Ocupação de células

Grid  |  Prioridade P0  |  Tamanho M  |  Marco M0

**Descrição:** Manter registro de unidade por célula.

**Especificação técnica / arquivos:** Criar BoardOccupancy ou componente equivalente com register, release, move e get_occupant; atualização atômica.

**Critérios de aceite:** Nunca há dois ocupantes; origem/destino atualizados corretamente.

**Testes e validação:** Testar duplicidade, movimento, liberação e consulta.

**Dependências:** 006, 008.

### RPG-010 — Células alcançáveis

Grid  |  Prioridade P0  |  Tamanho M  |  Marco M1

**Descrição:** Calcular destinos no alcance com custo 1 por célula.

**Especificação técnica / arquivos:** Criar Pathfinder com BFS/custo uniforme; inimigos bloqueiam; aliados atravessáveis, mas não são destino; respeitar limites.

**Critérios de aceite:** Retorna destinos válidos até alcance, excluindo origem e células finais ocupadas.

**Testes e validação:** Testar aliados, inimigos, bordas e alcance.

**Dependências:** 007, 009.

### RPG-011 — Busca de caminho

Grid  |  Prioridade P0  |  Tamanho M  |  Marco M1

**Descrição:** Encontrar rota válida até destino alcançável.

**Especificação técnica / arquivos:** Pathfinder retorna sequência ordenada de células; usar mesmas regras de custo/bloqueio; desempate determinístico técnico.

**Critérios de aceite:** Caminho contínuo, sem repetição, inicia adjacente e termina no destino.

**Testes e validação:** Testar rota direta, alternativa e sem caminho.

**Dependências:** 010.

### RPG-012 — Seleção de unidade

Grid  |  Prioridade P0  |  Tamanho P  |  Marco M1

**Descrição:** Separar seleção da lógica de desenho e mouse bruto.

**Especificação técnica / arquivos:** BattleController identifica unidade por ocupação/célula ou hit area; mantém seleção única; emite sinal para UI/grid.

**Critérios de aceite:** Selecionar/trocar unidade funciona com Units separado; sem hacks de metadados.

**Testes e validação:** Testar selecionar, trocar e clicar em vazio.

**Dependências:** 003, 008, 009.

### RPG-013 — Pré-visualização de movimento

Grid  |  Prioridade P0  |  Tamanho M  |  Marco M1

**Descrição:** Mostrar destinos e caminho sem mover unidade.

**Especificação técnica / arquivos:** Grid desenha dados calculados por Pathfinder; controller mantém destino temporário; preview não altera estado lógico.

**Critérios de aceite:** Destinos/caminho destacados; unidade permanece na origem até confirmar.

**Testes e validação:** Testar cursor válido/inválido e deseleção.

**Dependências:** 010, 011, 012.

### RPG-014 — Confirmar/cancelar movimento

Grid  |  Prioridade P0  |  Tamanho M  |  Marco M1

**Descrição:** Implementar fluxo explícito de preview, confirmação e cancelamento.

**Especificação técnica / arquivos:** Controller mantém caminho temporário; confirmar move e atualiza ocupação; cancelar limpa preview sem consumir movimento.

**Critérios de aceite:** Só confirmação move; cancelamento não consome ação; inválidos não confirmam.

**Testes e validação:** Testar confirmar, cancelar e ocupação.

**Dependências:** 013.

### RPG-015 — Regras de passagem e destino

Grid  |  Prioridade P0  |  Tamanho M  |  Marco M1

**Descrição:** Aplicar bloqueios de aliados/inimigos.

**Especificação técnica / arquivos:** Pathfinder/validator: inimigo bloqueia passagem/destino; aliado pode ser atravessado, não pode ser destino; incapacitado libera célula; preparar interface para bloqueios futuros.

**Critérios de aceite:** Caminhos e destinos obedecem regras; sem obstáculos implementados ainda.

**Testes e validação:** Testar aliado no caminho/destino e inimigo bloqueando.

**Dependências:** 009, 010, 014.

### RPG-016 — Ordem de iniciativa

Turnos  |  Prioridade P1  |  Tamanho M  |  Marco M2

**Descrição:** Ordenar unidades por Velocidade e Inteligência.

**Especificação técnica / arquivos:** TurnManager calcula ordem uma vez no início; empate total permanece pendente, não inventar terceiro critério.

**Critérios de aceite:** Ordem fixa; desempate não decidido fica documentado.

**Testes e validação:** Testar velocidades e empate parcial/total.

**Dependências:** 022; decisão de desempate.

### RPG-017 — Ciclo de rodadas e turnos

Turnos  |  Prioridade P1  |  Tamanho G  |  Marco M2

**Descrição:** Controlar unidade ativa e avanço da iniciativa.

**Especificação técnica / arquivos:** TurnManager mantém lista/índice, avança, reinicia rodada e trata unidades incapacitadas/removidas.

**Critérios de aceite:** Uma unidade ativa; ciclo consistente até condição terminal.

**Testes e validação:** Testar fim da lista e unidade removida.

**Dependências:** 016, 024.

### RPG-018 — Limite de movimento por turno

Turnos  |  Prioridade P1  |  Tamanho M  |  Marco M2

**Descrição:** Registrar movimento já utilizado.

**Especificação técnica / arquivos:** Estado do turno guarda flag; consumir somente após movimento confirmado, nunca no preview/cancelamento.

**Critérios de aceite:** No máximo um movimento confirmado por turno.

**Testes e validação:** Testar confirmação, cancelamento e segunda tentativa.

**Dependências:** 014, 017.

### RPG-019 — Limite de ação principal

Turnos  |  Prioridade P1  |  Tamanho M  |  Marco M2

**Descrição:** Registrar ação principal já utilizada.

**Especificação técnica / arquivos:** Validator verifica disponibilidade; consumir após resolução bem-sucedida; não definir ações gratuitas/exceções sem PO.

**Critérios de aceite:** Uma ação principal por turno; falha não consome ação.

**Testes e validação:** Testar ação válida, inválida e segunda ação.

**Dependências:** 005, 017.

### RPG-020 — Encerramento manual do turno

Turnos  |  Prioridade P1  |  Tamanho M  |  Marco M2

**Descrição:** Permitir encerrar turno sem gastar ações restantes.

**Especificação técnica / arquivos:** UI chama controller/TurnManager; bloqueia se batalha terminal; não executa ataque implicitamente.

**Critérios de aceite:** Jogador sempre consegue avançar turno; sem efeito de combate oculto.

**Testes e validação:** Testar sem ações, com ação restante e após fim.

**Dependências:** 017.

### RPG-021 — Regeneração de mana

Turnos  |  Prioridade P1  |  Tamanho M  |  Marco M3

**Descrição:** Aplicar 20% da mana máxima por turno.

**Especificação técnica / arquivos:** Implementar cálculo e aplicação no TurnManager após PO definir arredondamento e instante exato; limitar ao máximo.

**Critérios de aceite:** Regra implementada somente após decisão explícita; mana nunca excede máximo.

**Testes e validação:** Testar mana baixa/quase cheia/cheia e arredondamento escolhido.

**Dependências:** 022; decisão PO.

### RPG-022 — Atributos e recursos da unidade

Personagens  |  Prioridade P1  |  Tamanho M  |  Marco M2

**Descrição:** Modelar atributos de combate e recursos.

**Especificação técnica / arquivos:** Modelo tipado: HP/mana atual e máximos, Ataque, Defesa, Poder, Magia, Velocidade, Inteligência e movimento; separar configuração e estado mutável se útil.

**Critérios de aceite:** Valores tipados e recursos dentro dos limites.

**Testes e validação:** Testar inicialização e limites.

**Dependências:** 003, 006.

### RPG-023 — Cadastrar três aliados

Personagens  |  Prioridade P1  |  Tamanho M  |  Marco M3

**Descrição:** Criar dados dos três aliados predefinidos.

**Especificação técnica / arquivos:** Escolher Resources/JSON após inspeção; cadastrar somente dados aprovados; não inventar habilidades/atributos ausentes.

**Critérios de aceite:** Três definições carregáveis e instanciáveis.

**Testes e validação:** Testar campos obrigatórios e instanciação.

**Dependências:** 022; conteúdo aprovado.

### RPG-024 — Estados de unidade

Personagens  |  Prioridade P1  |  Tamanho M  |  Marco M3

**Descrição:** Representar ativo, incapacitado e removido/derrotado.

**Especificação técnica / arquivos:** Usar enum/estado explícito; incapacitado aliado continua alvo de revive e não ocupa célula; inimigo derrotado é removido.

**Critérios de aceite:** Transições explícitas; ocupação/ação dependem do estado.

**Testes e validação:** Testar transições e restrições por lado.

**Dependências:** 022.

### RPG-025 — Incapacitação de aliados

Personagens  |  Prioridade P1  |  Tamanho M  |  Marco M3

**Descrição:** Ao chegar a 0 HP, aliado incapacita e libera célula.

**Especificação técnica / arquivos:** CombatResolver limita HP a zero, altera estado, libera ocupação e bloqueia ações; manter referência para revive.

**Critérios de aceite:** Aliado não age nem ocupa célula, mas permanece elegível a revive.

**Testes e validação:** Testar dano letal, liberação e bloqueio de ação.

**Dependências:** 024, 009, 029.

### RPG-026 — Posicionamento inicial

Personagens  |  Prioridade P1  |  Tamanho P  |  Marco M3

**Descrição:** Configurar posições iniciais em coordenadas lógicas.

**Especificação técnica / arquivos:** Dados de cenário guardam célula inicial; validar limites, duplicidade e lado; iniciar com 1v1.

**Critérios de aceite:** Todas as unidades em células válidas e exclusivas; sem editar geometria para mudar posição.

**Testes e validação:** Testar posições duplicadas/fora do tabuleiro.

**Dependências:** 006, 009, 022.

### RPG-027 — Dados de habilidades

Combate  |  Prioridade P1  |  Tamanho M  |  Marco M3

**Descrição:** Modelar habilidades separadas da UI e execução.

**Especificação técnica / arquivos:** AbilityData/Resource com id, nome, tipo, custo e parâmetros definidos; campos de alcance/poder apenas quando aprovados.

**Critérios de aceite:** Dados carregam sem executar; campos obrigatórios validados.

**Testes e validação:** Testar dados válidos/incompletos.

**Dependências:** 022; conteúdo de habilidades.

### RPG-028 — Ataque básico

Combate  |  Prioridade P1  |  Tamanho M  |  Marco M3

**Descrição:** Implementar ataque básico após decisão do PO.

**Especificação técnica / arquivos:** PENDENTE: custo, ação consumida, alcance, alvo e parâmetros. Criar extensão sem assumir ataque gratuito ou custo zero.

**Critérios de aceite:** Critérios finais dependem da decisão; regra provisória não pode virar regra aprovada.

**Testes e validação:** Após decisão, testar custo, alcance, alvo, dano e ação.

**Dependências:** 027; decisão PO.

### RPG-029 — Fórmula de dano físico

Combate  |  Prioridade P1  |  Tamanho M  |  Marco M3

**Descrição:** Centralizar fórmula aprovada de dano.

**Especificação técnica / arquivos:** CombatResolver aplica max(1, poder + ataque - defesa); HP não fica negativo; estado tratado por componente próprio.

**Critérios de aceite:** Dano mínimo 1 e fórmula consistente.

**Testes e validação:** Testar defesa alta, dano mínimo e letal.

**Dependências:** 022, 024, 025, 027.

### RPG-030 — Fórmula de cura

Combate  |  Prioridade P1  |  Tamanho M  |  Marco M3

**Descrição:** Implementar cura por poder + magia.

**Especificação técnica / arquivos:** CombatResolver aplica cura até max HP; não reativa incapacitado automaticamente (revive separado).

**Critérios de aceite:** HP nunca excede máximo; cura comum não ressuscita.

**Testes e validação:** Testar cura parcial, acima do máximo e alvo incapacitado.

**Dependências:** 022, 024, 027.

### RPG-031 — Alcance e elegibilidade de alvos

Combate  |  Prioridade P1  |  Tamanho G  |  Marco M3

**Descrição:** Validar alvos de habilidades.

**Especificação técnica / arquivos:** Validator usa regras específicas definidas por habilidade; alcance, forma, alvo e LOS são pendências quando não descritos; distinguir estados de unidade.

**Critérios de aceite:** Alvo só é aceito se elegível segundo dados aprovados; sem regras inventadas.

**Testes e validação:** Testar dentro/fora do alcance e estados após definição.

**Dependências:** 027, 024; decisões PO.

### RPG-032 — Consumo de mana

Combate  |  Prioridade P1  |  Tamanho M  |  Marco M3

**Descrição:** Validar e descontar custo de habilidade.

**Especificação técnica / arquivos:** Checar mana antes dos efeitos; descontar somente após validação/execução; falha preserva mana e ação.

**Critérios de aceite:** Mana não negativa; custo aplicado uma vez.

**Testes e validação:** Testar mana exata/insuficiente e ação inválida.

**Dependências:** 021, 027, 031.

### RPG-033 — Cura individual

Combate  |  Prioridade P1  |  Tamanho M  |  Marco M3

**Descrição:** Executar habilidade de cura em alvo individual.

**Especificação técnica / arquivos:** Conectar seleção, alvo, validação, custo e fórmula; valores/alcance dependem de dados aprovados.

**Critérios de aceite:** Cura somente alvo válido; custo/ação uma vez; feedback claro.

**Testes e validação:** Testar aliado ferido, HP cheio, alvo inválido e mana insuficiente.

**Dependências:** 027, 030, 031, 032.

### RPG-034 — Ressurreição

Combate  |  Prioridade P1  |  Tamanho G  |  Marco M3

**Descrição:** Reviver aliado incapacitado conforme regra definida.

**Especificação técnica / arquivos:** Selecionar aliado incapacitado; localizar célula livre mais próxima do conjurador; retornar com 1 HP; não agir até próximo turno próprio. Desempate de células equidistantes ainda precisa decisão.

**Critérios de aceite:** Não sobrescreve ocupação; retorna ativo com 1 HP e bloqueio de ação até turno próprio seguinte.

**Testes e validação:** Testar célula livre, conjurador cercado, empate e bloqueio de ação.

**Dependências:** 024, 025, 027, 009; desempate PO.

### RPG-035 — Habilidades em área

Combate  |  Prioridade P2  |  Tamanho G  |  Marco M4

**Descrição:** Suportar habilidades AoE previstas.

**Especificação técnica / arquivos:** Calcular área em coordenadas lógicas; forma, raio, alvos e LOS devem ser definidos por habilidade/PO; reutilizar resolução individual.

**Critérios de aceite:** Afetados determinados uma vez e em ordem determinística.

**Testes e validação:** Testar bordas e múltiplos alvos após regras aprovadas.

**Dependências:** 027, 031; decisões PO.

### RPG-036 — Buffs, debuffs e status

Combate  |  Prioridade P2  |  Tamanho G  |  Marco M4

**Descrição:** Criar infraestrutura de efeitos temporários.

**Especificação técnica / arquivos:** StatusEffect/EffectManager; não definir duração, stacking, ordem de expiração ou cleanup ao incapacitar sem decisão.

**Critérios de aceite:** Aplicação/remoção isoladas; regras pendentes documentadas.

**Testes e validação:** Testar após decisões de duração e stacking.

**Dependências:** 027; decisões PO.

### RPG-037 — Modelo de dados dos inimigos

IA  |  Prioridade P1  |  Tamanho M  |  Marco M3

**Descrição:** Representar inimigos e perfis de comportamento.

**Especificação técnica / arquivos:** Reutilizar modelo de unidade; distinguir time/lado e perfil de IA por dados; evitar scripts duplicados.

**Critérios de aceite:** Inimigos configuráveis por dados.

**Testes e validação:** Testar dois perfis distintos.

**Dependências:** 022, 024.

### RPG-038 — Inimigo inicial 1v1

IA  |  Prioridade P1  |  Tamanho M  |  Marco M3

**Descrição:** Cadastrar primeiro inimigo do protótipo.

**Especificação técnica / arquivos:** Usar atributos aprovados; se faltarem dados, registrar bloqueio e pedir decisão; não inventar balanceamento final.

**Critérios de aceite:** Inimigo instanciável com dados completos.

**Testes e validação:** Testar carregamento, posição e atributos.

**Dependências:** 037, 026; conteúdo aprovado.

### RPG-039 — Seleção de alvo da IA

IA  |  Prioridade P1  |  Tamanho M  |  Marco M4

**Descrição:** Escolher alvo considerando proximidade, vulnerabilidade e ameaça.

**Especificação técnica / arquivos:** EnemyAI/TargetSelector usa critérios configuráveis por tipo; não introduzir pesos arbitrários sem documentar.

**Critérios de aceite:** Só seleciona alvos válidos; retorna vazio quando não há alvo.

**Testes e validação:** Testar alvo único, prioridades e incapacitados.

**Dependências:** 037, 031.

### RPG-040 — Movimento da IA

IA  |  Prioridade P1  |  Tamanho M  |  Marco M4

**Descrição:** Inimigo aproxima-se quando não pode atacar.

**Especificação técnica / arquivos:** Reutilizar Pathfinder e occupancy; escolher destino que reduza distância; não atravessar inimigos.

**Critérios de aceite:** Respeita alcance e bloqueios; sem caminho resulta em permanecer parado.

**Testes e validação:** Testar adjacente, distante, bloqueado e sem destino.

**Dependências:** 010, 011, 015, 039.

### RPG-041 — Ataque da IA

IA  |  Prioridade P1  |  Tamanho M  |  Marco M4

**Descrição:** Permitir ataque quando alvo e condições forem válidos.

**Especificação técnica / arquivos:** Reutilizar Validator e CombatResolver; custo e regra conforme habilidade aprovada; sem ataque básico presumido.

**Critérios de aceite:** IA não ataca alvo inválido nem ignora custo.

**Testes e validação:** Testar alvo válido/inválido, alcance e mana.

**Dependências:** 028, 029, 031, 032, 039.

### RPG-042 — IA usa validação central

IA  |  Prioridade P1  |  Tamanho P  |  Marco M4

**Descrição:** Impedir que IA contorne regras.

**Especificação técnica / arquivos:** Remover regras duplicadas; todas ações chamam ActionValidator e tratam motivos de falha.

**Critérios de aceite:** IA respeita limites, recursos e estados.

**Testes e validação:** Forçar ação inválida e verificar rejeição.

**Dependências:** 005, 039, 040, 041.

### RPG-043 — Finalizar turno inimigo

IA  |  Prioridade P1  |  Tamanho M  |  Marco M4

**Descrição:** Garantir que IA sempre conclua seu turno.

**Especificação técnica / arquivos:** Fluxo sequencial: alvo, mover se necessário, atacar se possível, finalizar; tratar sem alvo/caminho sem loop.

**Critérios de aceite:** Turno inimigo sempre termina sem travar batalha.

**Testes e validação:** Testar sem alvo, sem caminho, ataque e múltiplos inimigos.

**Dependências:** 017, 040, 041, 042.

### RPG-044 — HUD da unidade selecionada

UI  |  Prioridade P1  |  Tamanho M  |  Marco M3

**Descrição:** Exibir nome, HP e mana da unidade selecionada.

**Especificação técnica / arquivos:** Criar UI desacoplada; atualizar por sinais/estado, sem polling desnecessário.

**Critérios de aceite:** HUD reflete seleção, dano, cura e incapacitação.

**Testes e validação:** Testar seleção e atualização de recursos.

**Dependências:** 022, 012.

### RPG-045 — Exibir iniciativa

UI  |  Prioridade P1  |  Tamanho M  |  Marco M3

**Descrição:** Mostrar ordem e unidade ativa.

**Especificação técnica / arquivos:** UI consome lista do TurnManager e destaca participante ativo; não recalcula ordem.

**Critérios de aceite:** Ordem e destaque correspondem ao estado de batalha.

**Testes e validação:** Testar início, avanço e remoção.

**Dependências:** 016, 017.

### RPG-046 — Menu de ações e habilidades

UI  |  Prioridade P1  |  Tamanho G  |  Marco M3

**Descrição:** Permitir escolher ação/habilidade disponível.

**Especificação técnica / arquivos:** UI lista dados de AbilityData e consulta Validator; mostra custo/disponibilidade; regras ficam fora da UI.

**Critérios de aceite:** Seleção inicia fluxo de alvo/execução; indisponíveis explicadas.

**Testes e validação:** Testar troca de unidade, mana insuficiente e ação usada.

**Dependências:** 019, 027, 032.

### RPG-047 — Prévia de efeitos

UI  |  Prioridade P2  |  Tamanho M  |  Marco M4

**Descrição:** Exibir estimativa antes de confirmar quando aplicável.

**Especificação técnica / arquivos:** CombatResolver oferece cálculo sem efeitos colaterais; mostrar apenas valores determinísticos conhecidos.

**Critérios de aceite:** Preview não altera HP, mana ou ações; valor coincide com resolução.

**Testes e validação:** Testar preview repetido, cancelamento e execução.

**Dependências:** 029, 030, 046.

### RPG-048 — Feedback de ação inválida

UI  |  Prioridade P1  |  Tamanho P  |  Marco M3

**Descrição:** Explicar por que ação não pôde ocorrer.

**Especificação técnica / arquivos:** Mapear retornos do Validator para mensagens curtas; UI não reimplementa validação.

**Critérios de aceite:** Falha informa motivo e não consome recurso/ação.

**Testes e validação:** Testar alcance, alvo, mana e ação já usada.

**Dependências:** 005, 044, 046.

### RPG-049 — Feedback visual básico

UI  |  Prioridade P1  |  Tamanho M  |  Marco M4

**Descrição:** Sinalizar movimento, dano, cura e incapacitação com placeholders.

**Especificação técnica / arquivos:** Criar feedback temporário em camada de apresentação; efeitos não alteram lógica; sem assets finais.

**Critérios de aceite:** Eventos essenciais perceptíveis; jogo funciona sem assets externos.

**Testes e validação:** Testar movimento, dano, cura e incapacitação.

**Dependências:** 014, 025, 033.

### RPG-050 — Telas de vitória e derrota

UI  |  Prioridade P1  |  Tamanho M  |  Marco M4

**Descrição:** Apresentar resultado ao atingir condição terminal.

**Especificação técnica / arquivos:** Vitória: todos inimigos removidos; derrota: todos aliados incapacitados; simultaneidade = derrota. Bloquear ações após fim.

**Critérios de aceite:** Resultado correto uma vez; estado terminal imutável.

**Testes e validação:** Testar vitória, derrota e simultaneidade.

**Dependências:** 024, 025, 037, 029.

### RPG-051 — Reiniciar batalha

UI  |  Prioridade P1  |  Tamanho M  |  Marco M4

**Descrição:** Recriar batalha do estado inicial.

**Especificação técnica / arquivos:** Reinicializar unidades, ocupação, iniciativa e recursos pela configuração; evitar duplicar nós/sinais; sem save persistente.

**Critérios de aceite:** Estado inicial restaurado após vitória, derrota ou partida em andamento.

**Testes e validação:** Testar reinícios sucessivos e ausência de instâncias duplicadas.

**Dependências:** 026, 017, 050.

### RPG-052 — Validar batalha integrada 1v1

Marco  |  Prioridade P0  |  Tamanho G  |  Marco M5

**Descrição:** Entregar primeiro cenário jogável completo.

**Especificação técnica / arquivos:** Integrar seleção, movimento, ações aprovadas, turnos, IA, fim e reinício; placeholders permitidos; limitar ao conjunto de regras fechadas.

**Critérios de aceite:** Partida 1v1 pode ser concluída e reiniciada sem bloqueadores.

**Testes e validação:** Checklist ponta a ponta e várias partidas.

**Dependências:** Sistemas M0–M4 aplicáveis; pendências bloqueadoras resolvidas.

### RPG-053 — Expandir para 2v2

Marco  |  Prioridade P1  |  Tamanho M  |  Marco M6

**Descrição:** Adicionar segunda unidade por lado sem duplicar lógica.

**Especificação técnica / arquivos:** Alterar apenas dados de cenário; conferir ocupação, iniciativa, alvos e IA com coleções dinâmicas.

**Critérios de aceite:** 2v2 completo com quatro participantes.

**Testes e validação:** Partida 2v2 e regressão 1v1.

**Dependências:** 052; dados aprovados.

### RPG-054 — Expandir para 3v3

Marco  |  Prioridade P1  |  Tamanho M  |  Marco M7

**Descrição:** Atingir composição final de três aliados e três inimigos.

**Especificação técnica / arquivos:** Adicionar terceira unidade por lado via configuração; remover pressupostos de contagem fixa.

**Critérios de aceite:** Seis unidades aparecem e agem conforme estado.

**Testes e validação:** Partida 3v3 completa e reinício.

**Dependências:** 053; dados aprovados.

### RPG-055 — Cadastrar segundo e terceiro inimigos

IA  |  Prioridade P1  |  Tamanho M  |  Marco M7

**Descrição:** Completar três perfis inimigos.

**Especificação técnica / arquivos:** Criar dados/perfis aprovados e reutilizar IA; não inventar atributos/habilidades.

**Critérios de aceite:** Três inimigos instanciáveis com dados válidos.

**Testes e validação:** Testar carga, iniciativa, alvo e turno.

**Dependências:** 037, 038, 054; conteúdo aprovado.

### RPG-056 — Avaliar legibilidade do tabuleiro

Apresentação  |  Prioridade P1  |  Tamanho M  |  Marco M7

**Descrição:** Verificar legibilidade com seis unidades e placeholders.

**Especificação técnica / arquivos:** Revisar escala, sobreposição, seleção, caminho e HUD; ajustar apresentação sem alterar regras sem aprovação.

**Critérios de aceite:** Seis unidades distinguíveis e interação legível.

**Testes e validação:** Revisar resolução-alvo e testar cliques próximos.

**Dependências:** 054, 049.

### RPG-057 — Pan e zoom da câmera

Apresentação  |  Prioridade P2  |  Tamanho M  |  Marco M8

**Descrição:** Adicionar navegação da câmera.

**Especificação técnica / arquivos:** Criar BattleCamera; pan/zoom com limites; controles a confirmar; não afetar coordenadas lógicas.

**Critérios de aceite:** Tabuleiro visível em diferentes escalas sem perder interação.

**Testes e validação:** Testar limites e seleção após pan/zoom.

**Dependências:** 056; decisão de controles.

### RPG-058 — Rotação da câmera

Apresentação  |  Prioridade P2  |  Tamanho G  |  Marco M8

**Descrição:** Implementar rotação conforme decisão visual.

**Especificação técnica / arquivos:** Confirmar ângulos/eixo e abordagem 2D; não migrar para 3D por inferência; preservar conversão de mouse/célula.

**Critérios de aceite:** Rotação segue especificação e picking continua correto.

**Testes e validação:** Testar seleção e movimento em todas orientações aprovadas.

**Dependências:** 057; decisão PO.

### RPG-059 — Integrar assets aprovados

Apresentação  |  Prioridade P2  |  Tamanho G  |  Marco M9

**Descrição:** Substituir placeholders após combate funcional.

**Especificação técnica / arquivos:** Selecionar assets com licença e aprovação; manter visual separado de lógica; não alterar hitboxes sem validação.

**Critérios de aceite:** Assets aprovados integrados sem regressão funcional.

**Testes e validação:** Testes visuais/funcionais 1v1, 2v2, 3v3.

**Dependências:** 052, 054, 056; aprovação.

### RPG-060 — Testes de geometria do grid

QA  |  Prioridade P0  |  Tamanho M  |  Marco M0

**Descrição:** Cobrir coordenadas, vizinhos, distância e conversão.

**Especificação técnica / arquivos:** Criar testes automatizados de lógica, independentes de screenshot.

**Critérios de aceite:** Casos centro/borda/canto passam.

**Testes e validação:** Executar suíte.

**Dependências:** 002, 006–008.

### RPG-061 — Testes de movimento/pathfinding

QA  |  Prioridade P0  |  Tamanho M  |  Marco M1

**Descrição:** Cobrir alcance, caminho e ocupação.

**Especificação técnica / arquivos:** Testar custo, bloqueios, aliados atravessáveis, destino aliado inválido, limites, preview e cancelamento.

**Critérios de aceite:** Regras principais de movimento cobertas automaticamente.

**Testes e validação:** Executar testes e validação integrada.

**Dependências:** 002, 009–015.

### RPG-062 — Testes de combate

QA  |  Prioridade P1  |  Tamanho M  |  Marco M3

**Descrição:** Cobrir fórmulas, recursos e estados.

**Especificação técnica / arquivos:** Testar dano, cura, mana, incapacitação e revive após regras fechadas; pendências não contam como implementadas.

**Critérios de aceite:** Regras aprovadas cobertas.

**Testes e validação:** Casos de borda e estados inválidos.

**Dependências:** 002, 025, 029–034.

### RPG-063 — Testes de turnos e ações

QA  |  Prioridade P1  |  Tamanho M  |  Marco M3

**Descrição:** Cobrir iniciativa, avanço e limites de ações.

**Especificação técnica / arquivos:** Testar ordem, nova rodada, movimento/ação uma vez, cancelamento e encerramento; empate só após decisão.

**Critérios de aceite:** Regras de turno aprovadas cobertas.

**Testes e validação:** Executar suíte de turnos.

**Dependências:** 002, 016–020.

### RPG-064 — Testes de IA

QA  |  Prioridade P1  |  Tamanho M  |  Marco M4

**Descrição:** Validar alvo, movimento, ataque e conclusão de turno.

**Especificação técnica / arquivos:** Criar cenários determinísticos; controlar aleatoriedade se vier a existir.

**Critérios de aceite:** IA não viola regras nem trava turno.

**Testes e validação:** Testar sem alvo, sem caminho e múltiplos inimigos.

**Dependências:** 002, 039–043.

### RPG-065 — Testes de fim/reinício

QA  |  Prioridade P1  |  Tamanho M  |  Marco M4

**Descrição:** Cobrir vitória, derrota, simultaneidade e reinício.

**Especificação técnica / arquivos:** Testar condições terminais e ausência de estado residual após restart.

**Critérios de aceite:** Resultado e reinício consistentes.

**Testes e validação:** Executar partidas sequenciais.

**Dependências:** 002, 050, 051.

### RPG-066 — Validação integrada 1v1

QA  |  Prioridade P0  |  Tamanho M  |  Marco M5

**Descrição:** Gate de qualidade do primeiro cenário.

**Especificação técnica / arquivos:** Checklist ponta a ponta com seleção, movimento, ações aprovadas, turnos, IA, combate e restart.

**Critérios de aceite:** Partida completa sem bugs bloqueadores conhecidos.

**Testes e validação:** Executar múltiplas partidas e registrar bugs.

**Dependências:** 052, 060–065.

### RPG-067 — Validação integrada 2v2

QA  |  Prioridade P1  |  Tamanho M  |  Marco M6

**Descrição:** Gate de qualidade da expansão 2v2.

**Especificação técnica / arquivos:** Verificar quatro unidades, iniciativa, ocupação, IA, incapacitação, revive e restart.

**Critérios de aceite:** 2v2 completo sem bloqueadores; regressão 1v1 preservada.

**Testes e validação:** Partidas completas e regressão.

**Dependências:** 053, 061–065.

### RPG-068 — Validação integrada 3v3

QA  |  Prioridade P1  |  Tamanho G  |  Marco M7

**Descrição:** Gate final do MVP de combate.

**Especificação técnica / arquivos:** Validar seis unidades, combate completo, incapacitação, revive, vitória/derrota e restart.

**Critérios de aceite:** MVP 3v3 jogável e reiniciável, sem bloqueadores conhecidos.

**Testes e validação:** Partidas completas em resolução-alvo e registrar defeitos.

**Dependências:** 054, 055, 066, 067.

## 7. Pendências que exigem decisão do PO

- Ataque básico: custo de mana, se consome ação principal, alcance, alvo permitido e parâmetros.

- Desempate de iniciativa quando Velocidade e Inteligência forem iguais.

- Regeneração de mana: arredondamento dos 20% e instante de aplicação no ciclo do turno.

- Habilidades: custos/valores/alcance, formato de área, categorias de alvo e linha de visão.

- Ressurreição: critério de desempate quando mais de uma célula livre estiver igualmente próxima; custo/alcance conforme habilidade.

- Status/buffs/debuffs: duração, acúmulo, ordem de expiração e limpeza ao incapacitar/remover.

- Câmera: ângulos, eixo e controles de rotação.

- Atributos e habilidades definitivos dos três aliados e três inimigos.

## 8. Definition of Done

- Critérios de aceite atendidos sem ampliar escopo não aprovado.

- Projeto abre no Godot 4 sem erros ou warnings novos relevantes.

- Testes existentes passam; regras determinísticas novas recebem testes.

- Separação entre lógica, dados, coordenação e apresentação é respeitada.

- Nenhuma regra pendente foi assumida silenciosamente.

- Entrega lista arquivos, testes, resultados e limitações conhecidas.

## 9. Fontes e rastreabilidade

Consolida GDD RPG Tático Isométrico v0.2, revisão crítica do GDD v0.2, AGENTS.md e decisões de produto registradas na conversa. Quando houver divergência, prevalece a decisão explicitamente aprovada pelo PO; pontos não resolvidos permanecem pendentes.

O estado conhecido do projeto inclui battle.tscn, unit.tscn, hex_grid.gd, unit.gd e battle.gd. Os demais arquivos/classes são propostas e devem ser confirmados no repositório antes da implementação.
