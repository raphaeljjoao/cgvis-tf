#ifndef COLLISIONS_H
#define COLLISIONS_H

#include <glm/vec3.hpp>
#include <vector>
#include <cmath>

// ===================================================================
// TEMPLE RUN — Testes de intersecção (colisão).
// Arquivo separado conforme requisito do trabalho.
// Atende ao requisito do SPEC.md:
//   "Testes de intersecção: A colisão do personagem com um objeto causa
//    a derrota e a colisão de um personagem com uma moeda gera pontos."
// ===================================================================

// Structs compartilhadas entre main.cpp e collisions.cpp
struct Obstacle
{
    int   lane;       // -1 (esq), 0 (centro), +1 (dir)
    float z;          // posição em Z no mundo (negativa) — legacy
    float scale;      // raio da esfera placeholder
    glm::vec3 worldPos;  // posição calculada no mundo (com direção do segmento)
    int segmentIdx;      // índice do segmento ao qual pertence
};

struct Coin
{
    int   lane;       // -1, 0, +1
    float z;          // posição Z fixa no mundo — legacy
    bool  collected;  // true se já foi coletada
    glm::vec3 worldPos;  // posição calculada no mundo (com direção do segmento)
    int segmentIdx;      // índice do segmento ao qual pertence
};

// Testa colisão do player com todos os obstáculos.
// Retorna true se o player colidiu com algum obstáculo (derrota).
// A colisão é ignorada se o player está no ar (playerPos.y > threshold).
// Usa teste de distância ponto-esfera no plano XZ.
bool CheckObstacleCollision(glm::vec3 playerPos,
                            const std::vector<Obstacle>& obstacles,
                            float laneWidth,
                            float obstacleScale,
                            float playerRadius);

// Testa colisão do player com todas as moedas não coletadas.
// Marca collected=true para moedas alcançadas e retorna o número
// de moedas coletadas neste frame (para incrementar score).
// Usa teste de distância ponto-esfera em 3D.
int CheckCoinCollision(glm::vec3 playerPos,
                       std::vector<Coin>& coins,
                       float laneWidth,
                       float coinY,
                       float coinScale,
                       float playerRadius);

#endif // COLLISIONS_H