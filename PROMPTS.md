# Prompts utilizados para geração de código via IA

**Ferramenta:** Claude (Anthropic) via Cline/VS Code  
**Tipo:** Todo o código do jogo (exceto o template base fornecido pelo professor) foi gerado por IA.

---

## Commits gerados por IA

### `65b7366` — Remover cena demo (Passo 1)

**PROMPT:** "faça somente o ponto 1 de limpar a cena demo"

Removeu o carregamento dos modelos demo (sphere, bunny, plane) e suas chamadas de desenho no loop de renderização. Atualizou o título da janela para "INF01047 - Temple Run - 334042 / 333315". Manteve a infraestrutura (shaders, callbacks, texturas) intacta para os próximos passos.

---

### `6235be9` — Criar corredor finito (Passo 2)

**PROMPT:** "agora é hora de criar o corredor finito"

Recarregou `plane.obj` como tile do corredor. Adicionou constantes `TRACK_NUM_TILES=50`, `TRACK_TILE_LENGTH=4`, `TRACK_TILE_WIDTH=6`. Criou loop de instanciamento de 50 tiles com `Matrix_Translate` + `Matrix_Scale`. Ajustou `farplane` para -400 e câmera orbital para o centro do corredor. Atende ao requisito "Instâncias de objetos" do SPEC.md.

---

### `2ae357a` — Câmera em terceira pessoa (Passo 3)

**PROMPT:** "agora faça o passo 3 da camera"

Adicionou `g_PlayerPos` (vec3), `g_UseFreeCamera` (bool), `CAMERA_TPP_OFFSET=(0,4,8)`, `CAMERA_TPP_LOOKAT_OFFSET=(0,1,-3)`. Substituiu câmera orbital por `if/else` (3ª pessoa vs livre). Câmera segue `g_PlayerPos` automaticamente. Atende ao requisito "Diferentes tipos de câmeras" do SPEC.md.

---

### `c078808` — Player placeholder (Passo 4)

**PROMPT:** "faça o passo 4" (player placeholder bunny)

Carregou `bunny.obj` como placeholder do personagem. Adicionou `PLAYER_SCALE`. Desenhou bunny em `g_PlayerPos` com offset Y calculado via bounding box para alinhar base ao chão. Atende ao requisito "Malhas poligonais complexas" do SPEC.md.

---

### `843c342` — Movimento automático para frente (Passo 5)

**PROMPT:** "faça o proximo passo" (movimento automático com Δt)

Adicionou `PLAYER_SPEED=8`, `g_LastFrameTime`. Calcula `delta_time` via `glfwGetTime()`. Atualiza `g_PlayerPos.z -= PLAYER_SPEED * delta_time` a cada frame. Loop infinito reseta Z=0 ao fim do corredor. Atende ao requisito "Animações baseadas no tempo (Δt)" do SPEC.md.

---

### `464a7a2` — Troca de lanes (Passo 6)

**PROMPT:** "proximo passo" (troca de lanes com A/D e setas)

Adicionou `LANE_WIDTH=2`, `LANE_CHANGE_SPEED=12`, `g_PlayerLane`. Interpolação linear suave em X com delta_time. Handlers de teclado A/D e ←/→ no `KeyCallback`. Player não sai do corredor (clamp -1 a +1). Atende aos requisitos "Transformações geométricas controladas pelo usuário" e "Animações baseadas em Δt" do SPEC.md.

---

### `e79d117` — Salto com Bézier + Obstáculos (Passos 7 e 8)

**PROMPT (Passo 7):** "proximo passo" (salto com curva de Bézier cúbica)

Implementou função `BezierCubic(t, p0, p1, p2, p3)` com fórmula B(t) = (1-t)³P₀ + 3(1-t)²tP₁ + 3(1-t)t²P₂ + t³P₃. Pontos de controle P0=0, P1=4, P2=4, P3=0 (arco simétrico). Duração 0.7s. Tecla W/↑ dispara salto (single-jump). Atende ao requisito "Movimentação com curva Bézier cúbica" do SPEC.md.

**PROMPT (Passo 8):** "proximo passo" (obstáculos instanciados, espaçamento denso)

Carregou `sphere.obj`. Criou struct `Obstacle` com lane/z/scale. Geração determinística com `srand(42)`, espaçamento 10 unidades em Z. Cada obstáculo é uma instância de `the_sphere` posicionada em lane aleatória. Atende ao requisito "Instâncias de objetos" do SPEC.md.

---

### (pendente commit) — Moedas com rotação (Passo 9)

**PROMPT:** "passo 9" (moedas coletáveis com rotação contínua)

Criou struct `Coin` com lane/z/collected. Constantes `COIN_SCALE=0.3`, `COIN_Y=1.2`, `COIN_ROT_SPEED=3.0 rad/s`, `COIN_SPACING_Z=6`. Geração determinística após obstáculos. Desenho com `Matrix_Rotate_Y(current_time * COIN_ROT_SPEED)` para rotação contínua animada. Campo `collected` preparado para Passo 10 (colisão). Atende aos requisitos "Instâncias de objetos" e "Animações baseadas em Δt: rotação das moedas" do SPEC.md.

---

### (pendente commit) — Testes de colisão (Passo 10)

**PROMPT:** "passo 10" (testes de colisão obstáculo×player e moeda×player)

Modularizou os testes de intersecção em arquivos separados (`include/collisions.h` + `src/collisions.cpp`) movendo as structs `Obstacle` e `Coin` para o header e expondo duas funções:

- `CheckObstacleCollision(playerPos, obstacles, laneWidth, scale, jumpClearance)` — testa intersecção **esfera×esfera (AABB esférica)** entre o player (ponto na lane) e cada obstáculo. Usa `jumpClearance` como altura mínima do salto para considerar que o player passou por cima (se `playerPos.y > jumpClearance`, ignora a colisão).
- `CheckCoinCollision(playerPos, coins, laneWidth, coinY, coinScale, pickupRadius)` — itera as moedas não coletadas, calcula distância 3D ao player, e se ≤ `pickupRadius` marca `c.collected = true` e retorna a quantidade de moedas pegas no frame.

No `main.cpp`, dentro do loop principal:
- Após atualizar a posição do player, chama `CheckObstacleCollision`. Se `true`, **reseta** o player para a origem (`g_PlayerPos = vec3(0)`, `g_PlayerLane = 0`, `g_PlayerJumping = false`), zera `g_CoinScore` e re-marca todas as moedas como `collected = false` (jogo recomeça).
- Soma `CheckCoinCollision` em `g_CoinScore` para acumular o total coletado.
- Imprime `printf("COLISÃO! ...")` ao morrer para feedback no terminal.

Adicionado `src/collisions.cpp` à linha de compilação do `Makefile.macOS`. A geração das moedas teve o seed e o loop ajustados para garantir distribuição determinística reproduzível em testes (`srand(42)`).

Atende ao requisito **"Testes de intersecção"** do SPEC.md ("A colisão do personagem com um objeto causa a derrota e a colisão de um personagem com uma moeda gera pontos.").

---

### (pendente commit) — Iluminação Blinn-Phong em todos os objetos (Passo 11)

**PROMPT:** "preciso que agora seja feita a iluminação, Modelos de Iluminação em todos os objetos"

**Decisões com o usuário (modo plan):**
- Manter texturas atuais como Kd (texturas oficiais virão depois);
- Luz pontual deve **seguir o player** (efeito de "tocha");
- Moedas devem apenas **parecer** brilhantes (cor emissiva), sem afetar outros objetos.

**Mudanças no `src/shader_fragment.glsl` (reescrito):**
- Adicionado novo identificador `#define COIN 3` (separar moeda de obstáculo, que ambos compartilhavam `OBJ_SPHERE`).
- Novo uniform `uniform vec4 light_position_world` (posição da tocha em world space).
- Implementado **Blinn-Phong** com **duas fontes** + ambiente global + termo emissivo:
  - **Luz direcional** (sol): direção `vec4(1, 1, 0.5, 0)`, cor `vec3(1.0, 0.95, 0.85)`.
  - **Luz pontual** (tocha): cor `vec3(1.0, 0.8, 0.5)`, com atenuação `1/(1 + 0.05·d + 0.01·d²)` em função da distância ao fragmento.
  - **Luz ambiente** global: `Ia = vec3(0.25, 0.25, 0.30)`.
- Coeficientes `Kd` (textura), `Ks`, `Ka = Kd*α`, `Ke` (emissão) e `q` (expoente especular) **diferenciados por `object_id`**:
  | Objeto | Ks | q | Ke | Característica |
  |---|---|---|---|---|
  | `PLANE` | 0.05 | 8 | 0 | Chão fosco |
  | `BUNNY` | 0.30 | 32 | 0 | Player com leve brilho |
  | `SPHERE` (obstáculo) | 0.50 | 64 | 0 | Esfera bem reflexiva |
  | `COIN` | 0.90 (dourado) | 128 | `vec3(0.6, 0.5, 0.1)` | Brilhante + emissivo |
- Equação final: `color = Ka·Ia + Kd·(I_dir·lambert_dir + I_point·lambert_point·att) + Ks·(I_dir·spec_dir + I_point·spec_point·att) + Ke`.
- `lambert_*` via `max(0, dot(n, l))`; `spec_*` via Blinn-Phong com `h = normalize(l + v)` e `pow(max(0, dot(n, h)), q)`. Especular só é somado quando há luz incidente (`lambert > 0`), evitando highlights "fantasmas".
- Correção gamma final preservada (`pow(color, 1/2.2)`).

**Mudanças no `src/main.cpp`:**
- `#define OBJ_COIN 3`, mantendo coerência com o shader.
- `GLint g_light_position_uniform` declarado; capturado em `LoadShadersFromFiles()` via `glGetUniformLocation(..., "light_position_world")`.
- A cada frame, antes do desenho dos objetos: envia `light_pos = vec4(g_PlayerPos.x, g_PlayerPos.y + 3.0, g_PlayerPos.z + 2.0, 1.0)` (acima e ligeiramente atrás do player) com `glUniform4f`.
- No bloco de desenho das moedas, trocado `OBJ_SPHERE` por `OBJ_COIN` para que recebam o material dourado emissivo.

A tecla **R** (recarregar shaders) continua disponível e foi muito usada para iterar nos parâmetros sem recompilar.

Atende ao requisito **"Modelos de Iluminação em todos os objetos"** do SPEC.md ("Possuirá luz ambiente para iluminação global e luz pontual para elementos como fogo e moedas.").

---

## Nota

Os commits anteriores a `65b7366` (`c0e4b7d`, `7a3b61c`, `36ca731`, `6428874`, `e09be4e`, `53d2990`) são do template base do professor e da especificação — **não foram gerados por IA**.