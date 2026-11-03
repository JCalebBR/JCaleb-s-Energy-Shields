#!/usr/bin/env python3
"""Generates the shield hit textures as PNGs in addons/shields/Textures/Hit.

One tileable lightning pattern, written for every health colour (matches jces_main_healthColors):
- jces_shield_hit_<colour>_<step>_ca: full flash per fade step (0 brightest), swapped onto models without a Hit layer.
- jces_shield_hitlayer_<colour>_ca: for the Hit layer UV slide. The Hit faces' UVs are a thin strip in u, the slide
  moves it through the texture over the animation, so each column is one moment of the flash: clear at the strip
  (rest), a quick flash just past it, fading out well before the slide wraps back. The lightning is drawn much
  finer in u than v because the strip stretches a few pixels over the whole dome.
Convert them with the ".png -> .paa" task afterwards.

Usage: python3 tools/generate_hit_textures.py [seed]
"""

import sys
from pathlib import Path

import numpy as np
from PIL import Image

SIZE = 512
COLORS = [(0, 0.55, 0.68), (1, 0.78, 0), (0.9, 0.08, 0)]
# Peak vein opacity per fade step. The base fill matches the healthy outside texture (0.15).
STEPS = [0.95, 0.6, 0.3]
BASE_ALPHA = 0.15

# Hit strip in u (personal Gold model). The top and bottom faces stay around u 0.53-0.6, they must be clear at rest.
HIT_STRIP_START = 0.7982
# Layer texture size (u, v) and lightning frequency in cycles per texture (u, v) for each vein layer.
LAYER_SIZE = (2048, 512)
LAYER_VEINS = (((140, 5), 0.12, 1.0), ((260, 9), 0.08, 0.7))
# Flash envelope over the slide (0 to 1): rise until ATTACK, fade out by RELEASE.
ATTACK = (0.02, 0.07)
RELEASE = 0.7

OUTPUT_DIR = Path(__file__).resolve().parent.parent / "addons" / "shields" / "Textures" / "Hit"


def tileable_noise(rng, frequency, size=SIZE):
    """Band-limited random noise around a frequency (cycles per texture), tiles seamlessly."""
    fx = np.fft.fftfreq(size, 1 / size)[:, None]
    fy = np.fft.fftfreq(size, 1 / size)[None, :]
    radius = np.sqrt(fx * fx + fy * fy)
    band = np.exp(-(((radius - frequency) / (frequency * 0.5)) ** 2))
    spectrum = (rng.normal(size=(size, size)) + 1j * rng.normal(size=(size, size))) * band
    noise = np.real(np.fft.ifft2(spectrum))
    return noise / np.abs(noise).max()


def lightning(rng, size=SIZE):
    """Smooth bright ridges where the noise crosses zero, a coarse and a fine layer."""
    veins = np.zeros((size, size))
    for frequency, width, weight in ((5, 0.07, 1.0), (11, 0.05, 0.7)):
        ridge = np.clip(1 - np.abs(tileable_noise(rng, frequency, size)) / width, 0, 1) ** 1.5
        veins = np.maximum(veins, ridge * weight)
    return veins


def main():
    seed = int(sys.argv[1]) if len(sys.argv) > 1 else 40000
    veins = lightning(np.random.default_rng(seed))
    OUTPUT_DIR.mkdir(parents=True, exist_ok=True)
    for color_index, color in enumerate(COLORS):
        # Veins are the health colour pushed towards white so they read as energy.
        vein_rgb = np.array([c + (1 - c) * 0.5 for c in color])
        base_rgb = np.array(color)
        for step, peak in enumerate(STEPS):
            alpha = BASE_ALPHA + (peak - BASE_ALPHA) * veins
            mix = (veins * peak / alpha)[..., None]
            rgb = base_rgb * (1 - mix) + vein_rgb * mix
            pixels = np.dstack([rgb, alpha]) * 255
            path = OUTPUT_DIR / f"jces_shield_hit_{color_index}_{step}_ca.png"
            Image.fromarray(pixels.round().astype(np.uint8), "RGBA").save(path)
            print(f"Wrote {path}")

    # Hit layer: rows are v, columns are u.
    width, height = LAYER_SIZE
    rng = np.random.default_rng(seed + 1)
    fu = np.fft.fftfreq(width, 1 / width)[None, :]
    fv = np.fft.fftfreq(height, 1 / height)[:, None]
    layer_veins = np.zeros((height, width))
    for (cycles_u, cycles_v), vein_width, weight in LAYER_VEINS:
        radius = np.sqrt((fu / cycles_u) ** 2 + (fv / cycles_v) ** 2)
        spectrum = (rng.normal(size=(height, width)) + 1j * rng.normal(size=(height, width))) * np.exp(-(((radius - 1) / 0.5) ** 2))
        noise = np.real(np.fft.ifft2(spectrum))
        noise /= np.abs(noise).max()
        layer_veins = np.maximum(layer_veins, np.clip(1 - np.abs(noise) / vein_width, 0, 1) ** 1.5 * weight)

    # Slide position of each column, 0 at the strip.
    u = (np.arange(width) + 0.5) / width
    slide = (u - HIT_STRIP_START) % 1
    attack = np.clip((slide - ATTACK[0]) / (ATTACK[1] - ATTACK[0]), 0, 1)
    release = np.clip((RELEASE - slide) / (RELEASE - ATTACK[1]), 0, 1)
    envelope = (attack * attack * (3 - 2 * attack) * release ** 2)[None, :]

    for color_index, color in enumerate(COLORS):
        vein_rgb = np.array([c + (1 - c) * 0.5 for c in color])
        strength = 0.3 + 0.65 * layer_veins
        alpha = envelope * strength
        mix = (layer_veins * 0.65 / strength)[..., None]
        rgb = np.array(color) * (1 - mix) + vein_rgb * mix
        pixels = np.dstack([rgb, alpha]) * 255
        path = OUTPUT_DIR / f"jces_shield_hitlayer_{color_index}_ca.png"
        Image.fromarray(pixels.round().astype(np.uint8), "RGBA").save(path)
        print(f"Wrote {path}")

if __name__ == "__main__":
    main()
