// Pixel-art snow for Ghostty.
// Based on "Just snow" by Andrew Baldwin (2013) — https://www.shadertoy.com/
//   Original: twitter @baldand, www.thndl.com
// Reimplemented with pixel-snapped flakes, sin-free hashes, and bounding-box
// early-outs by Eli Saliman with Claude (2026).
// License: CC BY-NC-SA 3.0 — http://creativecommons.org/licenses/by-nc-sa/3.0/

#define LAYERS     5
#define DEPTH      0.4
#define WIDTH      0.4
#define SPEED      0.3
#define PIXEL_SIZE 2.0
#define SKIP_NEAR  4
#define CELL_SIZE  220.0

const vec3 SNOW_COLOR = vec3(0.95, 0.97, 1.0);
const float TAU = 6.28318530718;

// Sin-free 1D hash
float hash1(float n) {
    n = fract(n * 0.1031);
    n *= n + 33.33;
    return fract(n * 2.0);
}

// Cheap 3-component 2D hash
vec3 hash3(vec2 p, float seed) {
    vec3 q = vec3(dot(p, vec2(127.1, 311.7)),
                  dot(p, vec2(269.5, 183.3)),
                  dot(p, vec2(419.2, 371.9)));
    q = fract(q * 0.1031 + seed * 0.0937);
    q *= q + 33.33;
    return fract(q * q);
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    // Normal UVs only for sampling the terminal texture.
    vec2 uv = fragCoord.xy / iResolution.xy;

    // Top-left anchored coordinates so resizing the window doesn't remap the snowfield.
    vec2 snowCoord = vec2(fragCoord.x, iResolution.y - fragCoord.y);

    // Pixel snap in anchored space.
    vec2 snapped = (floor(snowCoord / PIXEL_SIZE) + 0.5) * PIXEL_SIZE;

    float acc = 0.0;

    for (int i = SKIP_NEAR; i < LAYERS; i++) {
        float fi = float(i);
        float depthScale = 1.0 + fi * DEPTH;

        // Cell size in actual screen pixels.
        float cellSize = CELL_SIZE / depthScale;

        // One pixel expressed in cell-local units.
        float pixSize = PIXEL_SIZE / cellSize;

        float speedJitter = 0.5 + 1.5 * hash1(fi * 1.731);
        float timeOffset  = hash1(fi * 4.219) * 1000.0;
        float driftAngle  = hash1(fi * 7.913) - 0.5;
        float t           = iTime + timeOffset;

        // Window-size-independent snowfield coordinates.
        vec2 q = -snapped / cellSize;

        // Falling downward.
        q.y -= SPEED * speedJitter * t /
               (1.0 + fi * DEPTH * 0.03);

        // Layer-wide diagonal drift, same spirit as the original shader.
        q.x += q.y * WIDTH * driftAngle * 2.0;

        vec2 cellId  = floor(q);
        vec2 cellPos = q - cellId;
        vec3 r       = hash3(cellId, fi);

        vec2 rawCenter = 0.1 + 0.8 * r.xy;
        vec2 center    = (floor(rawCenter / pixSize) + 0.5) * pixSize;

        // Per-flake motion:
        // - sideBias: each flake tends slightly left or right
        // - sway: slow meander
        // - shakeX/shakeY: tiny flutter
        float phase1    = TAU * hash1(dot(cellId, vec2(0.73, 1.91)) + fi * 0.17);
        float phase2    = TAU * hash1(dot(cellId, vec2(1.37, 0.59)) + fi * 0.43);

        float sideBias  = (r.x - 0.5) * 0.10;
        float sway      = sin(t * (0.25 + 0.55 * r.y) + phase1) * (0.05 + 0.08 * r.z);
        float shakeX    = sin(t * (1.6 + 2.4 * r.x) + phase2) * pixSize * (0.5 + 1.0 * r.y);
        float shakeY    = sin(t * (1.2 + 2.0 * r.z) + phase1 * 1.7) * pixSize * (0.3 + 0.7 * r.x);

        vec2 motion = vec2(sideBias + sway + shakeX, shakeY);

        // Quantize motion back to pixel steps so the style stays crisp/pixelated.
        motion = floor(motion / pixSize + 0.5) * pixSize;

        vec2 off = cellPos - (center + motion);
        float ax = abs(off.x);
        float ay = abs(off.y);

        float armScale = 1.0 - fi / float(LAYERS);
        float armLen   = pixSize * (0.4 + 1.6 * armScale);
        float thick    = pixSize * 0.5;

        // Bounding-box early out.
        float bbox = max(armLen, thick);
        if (ax > bbox || ay > bbox) continue;

        float h = step(ax, armLen) * step(ay, thick);
        float v = step(ay, armLen) * step(ax, thick);
        float flake = max(h, v);

        float depthFade = 1.0 / (1.0 + fi * 0.03);
        float alpha     = (0.25 + 0.75 * r.z) * depthFade;

        acc = max(acc, flake * alpha);
    }

    vec4 terminal = texture(iChannel0, uv);
    fragColor = vec4(terminal.rgb + SNOW_COLOR * acc, terminal.a);
}
