# Computação Gráfica e Visualização I (INF01047) - INF/UFRGS

A aplicação desenvolvida nesse trabalha simula o jogo Temple Run, o jogador controla um personagem que corre automaticamente por um caminho comcom obstáculos de fogo, troncos e partes do chão faltando. Existe uma tela para iniciar o jogo que leva para uma introdução, durante o jogo você poderá ver o contador de moedas, a distância percorrida e também a distância recorde da sessão. 
Ao colidir com um objeto, errar uma curva ou cair em um buraco o jogador morre e deve começar uma nova partida. Também existe o modo de camêra livre para que o jogador possa observar o mapa.

Tirando o primeiro commit, o trabalho foi totalmente realizado pelo Gustavo Pranstete, com uso de IA, correções manuais no código e testes. 

## Uso de IA
Para o desenvolvimento do trabalho foi utilizado inicialmente o Cline com o modelo Claude Opus 4.7 e posteriormente também foi usado o Codex com GPT 5.5 e pensamento médio. O uso das ferramentas se mostrou muito útil na maior parte do processo, falhando apenas em situações como dimensionar o tamanho dos objetos/items no jogo e na busca de texturas online.

## Imagens do jogo

<adicionar>

## Manual da aplicação
**Controles**
Clique em Jogar para iniciar.
A ou Seta esquerda: mover para a lane da esquerda.
D ou Seta direita: mover para a lane da direita.
W ou Seta para cima: pular.
Nas curvas, Seta esquerda ou Seta direita: virar para o lado indicado pelo caminho.
C: alternar entre câmera em terceira pessoa e câmera livre.
Mouse em câmera livre: arrastar para girar a câmera.
Scroll do mouse: aproximar ou afastar a câmera.
Esc: fechar a aplicação.
Durante a partida, a tela mostra moedas coletadas, distância percorrida e recorde da sessão. Ao colidir com fogo, tronco, cair em um buraco ou errar uma curva, o jogo termina e a tela final mostra o desempenho.

## Compilação
O jogo foi desenvolvido em um macbook, para compilar foi necessário apenas rodar o comando: `make -f Makefile.macOS run`