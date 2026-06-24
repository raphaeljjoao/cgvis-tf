#version 330 core

// Atributos de fragmentos recebidos como entrada ("in") pelo Fragment Shader.
// Neste exemplo, este atributo foi gerado pelo rasterizador como a
// interpolação da posição global e a normal de cada vértice, definidas em
// "shader_vertex.glsl" e "main.cpp".
in vec4 position_world;
in vec4 normal;

// Posição do vértice atual no sistema de coordenadas local do modelo.
in vec4 position_model;

// Coordenadas de textura obtidas do arquivo OBJ (se existirem!)
in vec2 texcoords;

// Matrizes computadas no código C++ e enviadas para a GPU
uniform mat4 model;
uniform mat4 view;
uniform mat4 projection;

// Identificador que define qual objeto está sendo desenhado no momento
#define SPHERE 0
#define BUNNY  1
#define PLANE  2
#define COIN   3
#define ENEMY  4
#define WATER  5
uniform int object_id;

// Parâmetros da axis-aligned bounding box (AABB) do modelo
uniform vec4 bbox_min;
uniform vec4 bbox_max;

// Variáveis para acesso das imagens de textura
uniform sampler2D TextureImage0;
uniform sampler2D TextureImage1;
uniform sampler2D TextureImage2;
uniform sampler2D TextureImage3;
uniform sampler2D TextureImage4;
uniform sampler2D TextureImage5;

// Posição (em world space) da luz pontual que segue o player (tipo "tocha").
// Setada por frame em main.cpp.
uniform vec4 light_position_world;

// O valor de saída ("out") de um Fragment Shader é a cor final do fragmento.
out vec4 color;

// Constantes
#define M_PI   3.14159265358979323846
#define M_PI_2 1.57079632679489661923

void main()
{
    // Obtemos a posição da câmera utilizando a inversa da matriz que define o
    // sistema de coordenadas da câmera.
    vec4 origin = vec4(0.0, 0.0, 0.0, 1.0);
    vec4 camera_position = inverse(view) * origin;

    // Posição do fragmento no sistema de coordenadas global (World).
    vec4 p = position_world;

    // Normal do fragmento atual.
    vec4 n = normalize(normal);

    // Se estamos renderizando uma back-face, invertemos a normal para
    // que a iluminação funcione corretamente (player sem backface culling).
    if (!gl_FrontFacing)
        n = -n;

    // ============================================================
    // FONTE 1 — Luz direcional (sol). Direção fixa no mundo.
    // ============================================================
    vec4  l_dir       = normalize(vec4(1.0, 1.0, 0.5, 0.0));
    vec3  I_dir       = vec3(1.0, 0.95, 0.85); // cor do "sol"

    // ============================================================
    // FONTE 2 — Luz pontual (tocha que segue o player).
    // Inclui atenuação suave em função da distância.
    // ============================================================
    vec4  l_point_vec = light_position_world - p;
    float d_point     = length(l_point_vec);
    vec4  l_point     = normalize(l_point_vec);
    vec3  I_point     = vec3(1.0, 0.8, 0.5); // cor amarelada de tocha
    float attenuation = 1.0 / (1.0 + 0.05 * d_point + 0.01 * d_point * d_point);

    // Vetor que define o sentido da câmera em relação ao ponto atual.
    vec4 v = normalize(camera_position - p);

    // Vetores half para Blinn-Phong (uma para cada fonte).
    vec4 h_dir   = normalize(l_dir   + v);
    vec4 h_point = normalize(l_point + v);

    // Coordenadas de textura U e V
    float U = 0.0;
    float V = 0.0;

    // Coeficientes de iluminação (preenchidos por objeto)
    vec3 Kd;            // refletância difusa (geralmente vem da textura)
    vec3 Ks;            // refletância especular
    vec3 Ka;            // refletância ambiente
    vec3 Ke;            // emissão (luz própria, não afetada por iluminação)
    float q;            // expoente especular (Blinn-Phong)

    // Luz ambiente global (cor da iluminação indireta da cena).
    vec3 Ia = vec3(0.25, 0.25, 0.30);

    if ( object_id == SPHERE )
    {
        // Projeção esférica para textura (mantida do código original).
        vec4 bbox_center = (bbox_min + bbox_max) / 2.0;
        vec4 d = position_model - bbox_center;

        float rho   = length(d);
        float theta = atan(d.x, d.z);
        float phi   = asin(d.y / rho);

        U = (theta + M_PI) / 2.0 / M_PI;
        V = (phi   + M_PI_2) / M_PI;

        Kd = texture(TextureImage0, vec2(U,V)).rgb;
        Ks = vec3(0.75, 0.42, 0.12);
        Ka = Kd * 0.25;
        Ke = Kd * 0.95 + vec3(0.75, 0.28, 0.04);
        q  = 96.0;
    }
    else if ( object_id == BUNNY )
    {
        // Usa as UVs do próprio modelo (player.obj tem mapeamento UV).
        U = texcoords.x;
        V = texcoords.y;

        Kd = texture(TextureImage3, vec2(U,V)).rgb;
        Ks = vec3(0.3, 0.3, 0.3);   // player: leve brilho
        Ka = Kd * 0.20;
        Ke = vec3(0.0);
        q  = 32.0;
    }
    else if ( object_id == PLANE )
    {
        U = texcoords.x;
        V = texcoords.y;

        Kd = texture(TextureImage1, vec2(U,V)).rgb;
        Ks = vec3(0.05, 0.05, 0.05); // chão: praticamente fosco
        Ka = Kd * 0.20;
        Ke = vec3(0.0);
        q  = 8.0;
    }
    else if ( object_id == COIN )
    {
        // O modelo coin.obj traz UVs próprias; usamos elas diretamente
        // com a textura Metal007 (TextureImage2) — uma textura metálica
        // dourada que faz a moeda parecer ouro reluzente.
        U = texcoords.x;
        V = texcoords.y;

        Kd = texture(TextureImage2, vec2(U,V)).rgb;
        Ks = vec3(0.9, 0.7, 0.2);   // dourado bem reflexivo
        Ka = Kd * 0.30;
        // Termo emissivo: faz a moeda *parecer* brilhante mesmo no escuro,
        // sem precisar afetar outros objetos da cena.
        Ke = vec3(0.4, 0.3, 0.05);
        q  = 128.0;
    }
    else if ( object_id == ENEMY )
    {
        U = texcoords.x;
        V = texcoords.y;

        Kd = texture(TextureImage4, vec2(U,V)).rgb;
        Ks = vec3(0.3, 0.3, 0.3);
        Ka = Kd * 0.20;
        Ke = vec3(0.0);
        q  = 32.0;
    }
    else if ( object_id == WATER )
    {
        // Coordenadas globais mantêm o padrão estável enquanto o plano
        // acompanha o jogador, além de repetir a textura sem esticá-la.
        U = position_world.x * 0.035;
        V = position_world.z * 0.035;

        Kd = texture(TextureImage5, vec2(U,V)).rgb;
        Ks = vec3(0.45, 0.60, 0.55);
        Ka = Kd * 0.35;
        Ke = Kd * 0.05;
        q  = 48.0;
    }
    else
    {
        // Fallback: rosa "missing material" (ajuda a detectar object_id errado)
        Kd = vec3(1.0, 0.0, 1.0);
        Ks = vec3(0.0);
        Ka = vec3(0.0);
        Ke = vec3(0.0);
        q  = 1.0;
    }

    // ============================================================
    // Equação de iluminação (Blinn-Phong) — soma das contribuições
    // de cada fonte de luz + ambiente global + emissão própria.
    // ============================================================

    // Lambert (difuso) por fonte
    float lambert_dir   = max(0.0, dot(n, l_dir));
    float lambert_point = max(0.0, dot(n, l_point));

    // Blinn-Phong (especular) por fonte — só faz sentido se houver luz incidente
    float spec_dir   = (lambert_dir   > 0.0) ? pow(max(0.0, dot(n, h_dir)),   q) : 0.0;
    float spec_point = (lambert_point > 0.0) ? pow(max(0.0, dot(n, h_point)), q) : 0.0;

    vec3 ambient_term  = Ka * Ia;
    vec3 diffuse_term  = Kd * ( I_dir * lambert_dir
                              + I_point * lambert_point * attenuation );
    vec3 specular_term = Ks * ( I_dir * spec_dir
                              + I_point * spec_point * attenuation );

    color.rgb = ambient_term + diffuse_term + specular_term + Ke;

    // NOTE: Se você quiser fazer o rendering de objetos transparentes, é
    // necessário:
    // 1) Habilitar a operação de "blending" de OpenGL logo antes de realizar o
    //    desenho dos objetos transparentes, com os comandos abaixo no código C++:
    //      glEnable(GL_BLEND);
    //      glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    // 2) Realizar o desenho de todos objetos transparentes *após* ter desenhado
    //    todos os objetos opacos; e
    // 3) Realizar o desenho de objetos transparentes ordenados de acordo com
    //    suas distâncias para a câmera (desenhando primeiro objetos
    //    transparentes que estão mais longe da câmera).
    color.a = 1.0;

    // Cor final com correção gamma, considerando monitor sRGB.
    color.rgb = pow(color.rgb, vec3(1.0,1.0,1.0)/2.2);
}
