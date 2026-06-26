# Prompts utilizados para geração de código via IA

Este arquivo registra os prompts associados aos commits cujo título começa com
`[IA]`, conforme solicitado nas regras do trabalho. O texto abaixo foi extraído
das mensagens de commit no histórico do Git.

## Commits com `[IA]`

### `65b7366` — Remover cena demo

**PROMPT:** "remova a cena demo"
**COMMIT:** `65b7366`

### Criar corredor finito

**PROMPT:** "crie um corredor finito estilo temple run"
**COMMIT:** `6235be9`

### Câmera em terceira pessoa

**PROMPT:** "coloque uma camera em terceira pessoa seguindo o jogador e prepare o terreno para camera livre"
**COMMIT:** `2ae357a`

### Player placeholder

**PROMPT:** coloque um player placeholder usando bunn
**COMMIT:** `c078808`

### Movimento automático para frente

**PROMPT:** faça o movimento automático do player com Δt 
**COMMIT:** `843c342`

### Troca de lanes

**PROMPT:** adicione movimento de troca de lanes usando A/D e setas
**COMMIT:** `464a7a2`


### Salto com Bézier + Obstáculos

**PROMPT:** faça o player saltar usando a curva de bezier para isso, também instancie os obstaculos e defina um espaçamento mediano para eles, use the sphere para isso
**COMMIT:** `e79d117`

### Moedas com rotação

**PROMPT:** faça moedas para serem coletadas e com rotação animada
**COMMIT:** `4d6aee6247857fcedae3fe1eec7195f9d6866539`

### Testes de colisão (Passo 10)

**PROMPT:** faça o teste de colisão entre a moeda (benefico) e obstaculos (player morre), as colisões devem ser feitas em um arquivo separado collisions.cpp, também faça o modelo de iluminação para todos objetos e player.
**COMMIT:** `7c2ff8c2fbf7cbc55818359c28e285bcf76b3a39`

**PROMPT:** "preciso que exista um toogle para mudar a perspectiva de camera para camera livre, deve ter algo pré planejado nos arquivos já"
**COMMIT:** `7c2ff8c2fbf7cbc55818359c28e285bcf76b3a39`


### Mapa infinito, com alteração de orientação
**PROMPT:** tem como fazer algo no estilo temple run, onde o personagem está sempre correndo para frente e em algum momento o mapa muda de direção para esquerda/direita e ele deve virar junto senão perde?
**COMMIT:** `ca350f8a1f31c67fa71207f6ab92fd3fe49db0c2`

### Paredes laterais e novos objetos

**PROMPT:** "é possivel fazer uma parede com partes mais altas e mais baixas ao lado da pista, similar com a do temple run, pode usar o mesmo png do chão. [EU] adicionar objs novos"
**COMMIT:** `0001d03`

### Introdução cinematográfica

**PROMPT:** "quero que nos primeiros segundos a camera comece frontal e gire até ficar focada no personagem, adicione instancias do enemy.obj nesse inicio, para ficar igual a abertura do jogo temple run mesmo"
**COMMIT:** `4811635`

### Intro segura, paredes e profundidade do chão

**PROMPT:** "ajuste a introdução para não ter obstaculos e moedas, ajuste as paredes e a profundidade do chão do mapa"
**COMMIT:** `8090c66`

### Animação visual do personagem

**PROMPT:** "sei que estou com um player obj fixo, faça as alterações necessarias pra deixar a animação dele menos estatica"
**COMMIT:** `44a5bb1`

### Tela inicial e tela final com blur

**PROMPT:** "Faça uma tela inicial e final com blur, com botão para jogar e na final com quantas moedas foram pegas"
**COMMIT:** `b1deb8b`

### Fogo mais realista

**PROMPT:** "faça o fogo parecer mais brilhante e mais real, tambem aumente seu tamanho sem afetar a colisão"
**COMMIT:** `109b822`

### Obstáculo de tronco deitado

**PROMPT:** "adicionei arquivos relacionados com data/treeTripDownHorz_prefab.obj, quero que seja um obstaculo de tronco deitado, que ocupe duas lanes e ocorra alternadamente com o fogo, mas não tão proximo muitas vezes para permitir a jogabilidade"
**COMMIT:** `b53ced7`

### Contagem de metros e recorde da sessão

**PROMPT:** "tem como fazer uma contagem de metros e no final mostrar qual foi o recorde da sessão?"
**COMMIT:** `46573e1`

## Arrumar bug nas curvas

**PROMPT:** "quando está na parte de virar para uma nova rota, o chão começa no meio do caminho e parece q tem uma lane faltando"
**COMMIT:** `4a0817c8c71d0167a0e206d7c7e5e82fe194d141`