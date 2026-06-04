#version 460 core
#include <flutter/runtime_effect.glsl>

precision highp float;

// Uniforms (set via setFloat in this exact order):
//   0,1 -> uResolution (vec2)
//   2   -> uTime (float, seconds)
//   3,4 -> uCameraOffset (vec2, world-space camera position for parallax)
uniform vec2 uResolution;
uniform float uTime;
uniform vec2 uCameraOffset;

out vec4 fragColor;

// --- hash / noise helpers ---------------------------------------------------
float hash21(vec2 p) {
  p = fract(p * vec2(123.34, 345.45));
  p += dot(p, p + 34.345);
  return fract(p.x * p.y);
}

vec2 hash22(vec2 p) {
  float n = hash21(p);
  return vec2(n, hash21(p + n));
}

float valueNoise(vec2 p) {
  vec2 i = floor(p);
  vec2 f = fract(p);
  vec2 u = f * f * (3.0 - 2.0 * f);
  float a = hash21(i + vec2(0.0, 0.0));
  float b = hash21(i + vec2(1.0, 0.0));
  float c = hash21(i + vec2(0.0, 1.0));
  float d = hash21(i + vec2(1.0, 1.0));
  return mix(mix(a, b, u.x), mix(c, d, u.x), u.y);
}

// fractional Brownian motion: stacked octaves of value noise
float fractalNoise(vec2 point) {
  float value = 0.0;
  float amplitude = 0.5;
  for (int i = 0; i < 5; i++) {
    value += amplitude * valueNoise(point);
    point *= 2.02;
    amplitude *= 0.5;
  }
  return value;
}

// One twinkling star layer. `scale` controls density, `parallax` how much it
// drifts with the camera (nearer layers move more).
vec3 starLayer(vec2 uv, float scale, float parallax, float brightness) {
  vec2 scaledUv = uv * scale + uCameraOffset * parallax;
  vec2 cell = floor(scaledUv);
  vec2 cellPosition = fract(scaledUv);

  vec3 color = vec3(0.0);
  // sample the 3x3 neighbourhood so stars near cell edges still glow
  for (int y = -1; y <= 1; y++) {
    for (int x = -1; x <= 1; x++) {
      vec2 offset = vec2(float(x), float(y));
      vec2 cellId = cell + offset;
      vec2 randomValue = hash22(cellId);
      // only some cells contain a star
      if (randomValue.x > 0.62) {
        vec2 starPosition = offset + randomValue - cellPosition;
        float distance = length(starPosition);
        float core = brightness * 0.012 / (distance * distance + 0.0008);
        // twinkle
        float twinkle =
            0.6 + 0.4 * sin(uTime * (1.5 + randomValue.y * 3.0)
                + randomValue.x * 30.0);
        // subtle colour variation: blue-white to warm
        vec3 tint =
            mix(vec3(0.7, 0.8, 1.0), vec3(1.0, 0.85, 0.7), randomValue.y);
        color += core * twinkle * tint;
      }
    }
  }
  return color;
}

void main() {
  vec2 fragCoord = FlutterFragCoord();
  vec2 uv = (fragCoord - 0.5 * uResolution) / uResolution.y;

  // deep-space base gradient
  vec3 color = mix(vec3(0.02, 0.02, 0.06), vec3(0.04, 0.02, 0.10),
                   uv.y * 0.5 + 0.5);

  // drifting nebula clouds (cheap fractal noise), tinted purple/teal
  vec2 nebulaUv = uv * 1.4 + uCameraOffset * 0.00008;
  float nebulaDensity = fractalNoise(nebulaUv + vec2(uTime * 0.01, uTime * 0.006));
  float nebulaShade = fractalNoise(nebulaUv * 2.0 - vec2(uTime * 0.008, 0.0));
  vec3 nebula = mix(vec3(0.25, 0.05, 0.35), vec3(0.04, 0.18, 0.30),
                    smoothstep(0.3, 0.9, nebulaShade));
  color += nebula * pow(smoothstep(0.35, 0.95, nebulaDensity), 2.0) * 0.55;

  // three parallax star layers (far -> near)
  color += starLayer(uv, 9.0, 0.00010, 0.6);
  color += starLayer(uv, 5.0, 0.00022, 0.9);
  color += starLayer(uv, 2.6, 0.00040, 1.3);

  // gentle vignette
  float vignette = smoothstep(1.3, 0.2, length(uv));
  color *= mix(0.7, 1.0, vignette);

  fragColor = vec4(color, 1.0);
}
