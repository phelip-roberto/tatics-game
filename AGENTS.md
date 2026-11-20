# AGENTS.md

## Project overview

This repository contains a single-player tactical RPG for PC, with Steam
as the intended release platform. It is being developed by a solo
developer who has full-stack software engineering experience but is
still learning Godot. Prefer clear, incremental implementation and
explain Godot-specific editor steps when relevant.

## Technology and constraints

-   Engine: Godot 4.x.
-   Language: GDScript.
-   Target: PC / Steam.
-   Single-player only. Do not introduce multiplayer, dedicated servers,
    online services, or networking unless explicitly requested.
-   Prefer ready-made art assets where appropriate; do not block
    gameplay development on final art.
-   Visual direction: isometric pixel-art environment with modern
    effects and UI.
-   The current prototype may use simple geometric placeholders. Do not
    mistake these for the final visual direction.
-   The user selected a 2D starting point in Godot. Do not migrate to 3D
    without explicit approval.

## Development principles

1.  Inspect relevant scenes, scripts, project settings, and existing
    structure before changing anything.
2.  Preserve working code. Refactor incrementally; do not replace
    working systems wholesale without approval.
3.  Do not assume files, nodes, class names, or paths exist. Verify them
    in the repository.
4.  Keep responsibilities separated, but avoid unnecessary abstractions
    and premature architecture.
5.  Make focused changes. Do not modify unrelated files or reformat
    large parts of the project without a reason.
6.  Explain which files changed, why they changed, and how to validate
    the result.
7.  Avoid unrequested dependencies and plugins. Prefer built-in Godot
    functionality.
8.  Do not invent gameplay decisions. Ask when an unresolved rule
    materially affects implementation.
9.  Keep the project runnable. Identify required editor actions and
    validate syntax or run relevant tests when possible.
10. Prefer reversible work. Encourage small Git commits before
    substantial refactors.

## Existing project context

The following paths have been established in the development
conversation. Verify that they still exist before editing:

-   `res://scenes/battle/battle.tscn` --- main battle scene.
-   `res://scenes/units/unit.tscn` --- reusable unit scene.
-   `res://scripts/grid/hex_grid.gd` --- current hex-grid
    implementation.
-   `res://scripts/units/unit.gd` --- current tactical unit
    implementation.

The current unit script uses the class name `TacticalUnit`.

The prototype already has code for drawing a flat-top hexagonal grid,
converting grid cells to local positions, centering/scaling the grid,
instantiating one test unit, drawing a simple unit placeholder,
selecting/deselecting the unit, and moving it within a simple
hex-distance range.

Some of these responsibilities currently live together in `hex_grid.gd`.
Refactor them in stages; do not assume separation has already been
completed.

## Intended architecture

This is the intended direction, not a claim that all files or nodes
already exist:

``` text
res://
├── scenes/
│   ├── battle/
│   │   └── battle.tscn
│   └── units/
│       └── unit.tscn
├── scripts/
│   ├── battle/
│   │   ├── battle.gd
│   │   └── battle_controller.gd
│   ├── grid/
│   │   ├── hex_grid.gd
│   │   └── pathfinder.gd
│   └── units/
│       └── unit.gd
├── assets/
│   ├── characters/
│   ├── terrain/
│   ├── effects/
│   └── ui/
└── docs/
```

Intended responsibilities:

-   `battle.gd`: initialize and coordinate the battle; create units and
    connect systems.
-   `hex_grid.gd`: grid geometry, drawing, coordinate conversion,
    bounds, and cell lookup.
-   `pathfinder.gd`: reachable-cell calculation and pathfinding,
    including blocked cells when introduced.
-   `unit.gd`: unit data and unit-specific visual behavior.
-   `battle_controller.gd`: player interaction, selection, movement
    preview, confirmation, and cancellation.

When separating grid rendering from units, account for local/global
coordinate transforms and parent transforms. Units must remain aligned
with their grid cells. Do not fix alignment with unexplained offsets.

## Gameplay direction and established rules

The prototype should first deliver one complete tactical battle. Keep
the initial implementation deliberately small.

Established decisions:

-   Hexagonal tactical grid, currently implemented with flat-top hex
    geometry.
-   No elevation or terrain-height system in the initial prototype.
-   Obstacles are deferred in the first prototype, but pathfinding
    should allow blocked cells later.
-   Enemies block movement.
-   Each traversed cell costs one movement point.
-   Movement range is defined per unit.
-   Movement should support path preview, confirmation, and
    cancellation.
-   Cancelling a movement preview must not consume the movement action.
-   Each unit has one movement action and one main action per turn; they
    may be used in either order.
-   Turn order is determined by Speed first, then Intelligence.
-   Initiative remains fixed during a battle.
-   Mana recovery is 20% of maximum mana per turn.
-   Allies at 0 HP become incapacitated and can be revived.
-   An incapacitated ally no longer occupies its tile.
-   A revived ally appears in the nearest free tile to the caster.
-   A revived ally returns with 1 HP and cannot act until its next turn.
-   Enemies at 0 HP are removed permanently and cannot be revived.
-   Victory occurs when all enemies are defeated.
-   Defeat occurs when all allies are incapacitated.
-   If victory and defeat conditions occur simultaneously, defeat takes
    priority.
-   Enemy AI should initially be simple.

Do not assume unresolved rules for basic attacks, ability targeting,
line of sight, or other combat details. Ask the user when those details
affect implementation.

## Preferred implementation order

1.  Stabilize and organize the existing battle scene and node hierarchy.
2.  Separate grid responsibilities from battle orchestration and player
    input without breaking current behavior.
3.  Implement pathfinding and reachable-cell calculation.
4.  Implement movement preview, confirmation, and cancellation.
5.  Define and implement the three initial allied units and their
    abilities.
6.  Implement turn order, action limits, and mana recovery.
7.  Implement enemies and basic enemy AI.
8.  Implement combat resolution, incapacitation, revival, victory, and
    defeat.
9.  Add obstacles and line-of-sight behavior when requested.
10. Improve visuals, effects, UI, camera controls, and content.

Do not jump ahead to story writing or large content production while
core mechanics are still being validated, unless explicitly requested.

## GDScript and Godot conventions

-   Use typed GDScript where it improves clarity, especially for public
    properties, function arguments, and return values.
-   Use `snake_case` for variables and functions.
-   Use `PascalCase` for custom class names.
-   Prefer `const` for fixed values and `@export` for intentional
    editor-configurable values.
-   Avoid magic numbers; name values that represent gameplay or layout
    decisions.
-   Use signals for decoupled communication between nodes when
    appropriate.
-   Avoid unnecessary global singletons/autoloads.
-   Keep gameplay logic separate from visual drawing code.
-   Keep scene node paths explicit and verify them against the actual
    scene tree.
-   Distinguish local, global, and canvas coordinates when working with
    `Node2D` transforms.
-   Do not use Godot 3.x APIs in a Godot 4 project.
-   If type inference is ambiguous, declare the type explicitly.

## Working with the developer

The developer prefers Portuguese explanations, clear ordered steps,
exact Godot editor instructions, incremental changes, and explicit
identification of existing files being changed versus new files being
created.

When implementing a feature:

1.  Inspect the current implementation first.
2.  Briefly state the intended change and affected files.
3.  Make the smallest coherent change.
4.  Explain required scene-tree or Inspector changes.
5.  Provide concrete validation steps.
6.  Report assumptions, limitations, and decisions that still require
    user input.

Do not assume the developer already knows where to click in Godot. Name
the relevant panel, node, property, or menu item when editor interaction
is required.

## Documentation and source of truth

-   Treat the user's latest explicit decisions as authoritative.
-   If a GDD or project document is present, inspect it before changing
    documented gameplay rules.
-   Do not silently reconcile conflicting documents or conversations.
    Point out conflicts and ask which source takes precedence.
-   Update project documentation when requested or when a significant
    confirmed decision changes.
-   Never present proposed architecture or future work as already
    implemented.
