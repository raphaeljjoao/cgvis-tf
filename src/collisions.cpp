// ===================================================================
// TEMPLE RUN — Implementação dos testes de intersecção (colisão).
//
// Este arquivo implementa as funções de detecção de colisão entre o
// player e os objetos do cenário (obstáculos e moedas).
//
// Método utilizado: teste de distância ponto-esfera.
//   - O player é aproximado como um ponto (centro da sua posição).
//   - Cada obstáculo/moeda é uma esfera com centro e raio conhecidos.
//   - Colisão ocorre quando dist(player, centro_objeto) < raio + margem.
//
// Para obstáculos: teste no plano XZ (ignora Y se player pulou por cima).
// Para moedas: teste em 3D (pode coletar em qualquer altura).
//
// Atende ao requisito do SPEC.md:
//   "Testes de intersecção: A colisão do personagem com um objeto causa
//    a derrota e a colisão de um personagem com uma moeda gera pontos."
// ===================================================================

#include "collisions.h"

bool CheckObstacleCollision(glm::vec3 playerPos,
                            const std::vector<Obstacle>& obstacles,
                            float laneWidth,
                            float obstacleScale,
                            float playerRadius)
{
    for (const Obstacle& o : obstacles)
    {
        // Centro do obstáculo no mundo (usando worldPos pré-calculado)
        float ox = o.worldPos.x;
        float oz = o.worldPos.z;

        // Distância no plano XZ entre player e centro do obstáculo
        float dx = playerPos.x - ox;
        float dz = playerPos.z - oz;
        float distXZ = std::sqrt(dx * dx + dz * dz);

        // Raio de colisão = raio do obstáculo + raio do player
        float collisionRadius = obstacleScale + playerRadius;

        if (distXZ < collisionRadius && playerPos.y < obstacleScale * 1.5f)
        {
            return true;  // COLISÃO! Derrota.
        }
    }

    return false;
}

int CheckCoinCollision(glm::vec3 playerPos,
                       std::vector<Coin>& coins,
                       float laneWidth,
                       float coinY,
                       float coinScale,
                       float playerRadius)
{
    int collected = 0;

    for (Coin& c : coins)
    {
        if (c.collected) continue;

        // Centro da moeda no mundo (usando worldPos pré-calculado)
        float cx = c.worldPos.x;
        float cy = c.worldPos.y;
        float cz = c.worldPos.z;

        // Distância 3D entre player e centro da moeda
        float dx = playerPos.x - cx;
        float dy = playerPos.y - cy;
        float dz = playerPos.z - cz;
        float dist3D = std::sqrt(dx * dx + dy * dy + dz * dz);

        float collectRadius = coinScale + playerRadius + 0.3f;

        if (dist3D < collectRadius)
        {
            c.collected = true;
            collected++;
        }
    }

    return collected;
}