#version 330 core

in vec2 uv;

uniform sampler2D screen_texture;
uniform vec2 screen_resolution;
uniform float blur_strength;

out vec4 color;

vec3 SampleBlur(vec2 center_uv, vec2 texel)
{
    vec2 axis = texel * blur_strength;

    vec3 blurred = texture(screen_texture, center_uv).rgb * 0.24;
    blurred += texture(screen_texture, center_uv + vec2( axis.x, 0.0)).rgb * 0.12;
    blurred += texture(screen_texture, center_uv + vec2(-axis.x, 0.0)).rgb * 0.12;
    blurred += texture(screen_texture, center_uv + vec2(0.0,  axis.y)).rgb * 0.12;
    blurred += texture(screen_texture, center_uv + vec2(0.0, -axis.y)).rgb * 0.12;

    blurred += texture(screen_texture, center_uv + vec2( axis.x,  axis.y) * 1.7).rgb * 0.07;
    blurred += texture(screen_texture, center_uv + vec2(-axis.x,  axis.y) * 1.7).rgb * 0.07;
    blurred += texture(screen_texture, center_uv + vec2( axis.x, -axis.y) * 1.7).rgb * 0.07;
    blurred += texture(screen_texture, center_uv + vec2(-axis.x, -axis.y) * 1.7).rgb * 0.07;

    return blurred;
}

void main()
{
    vec2 texel = 1.0 / screen_resolution;
    vec3 blurred = SampleBlur(uv, texel * 4.0);

    float vignette = smoothstep(0.95, 0.20, length(uv - vec2(0.5)));
    float panel_x = smoothstep(0.06, 0.20, uv.x) * (1.0 - smoothstep(0.80, 0.94, uv.x));
    float panel_y = smoothstep(0.12, 0.26, uv.y) * (1.0 - smoothstep(0.74, 0.88, uv.y));
    float panel_mask = panel_x * panel_y;

    float brightness = 0.64 + 0.08 * vignette - 0.16 * panel_mask;
    color = vec4(blurred * brightness, 1.0);
}
