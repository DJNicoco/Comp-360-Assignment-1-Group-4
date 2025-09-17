# COMP360 — 3D Terrain Prototype (Godot 4)

Single **Godot 4** project for the whole group. We generate a **grayscale FastNoiseLite image (Cellular + FBM/octaves)** and build a **3D grid of quads** whose vertex heights come from the image’s **red channel**. Texture UVs are 0..1 and match the heights; a **2×2 grid has no seams**; scale to **NxM** with tests ≤ **256×256**.

## Quick start
1. Open with **Godot 4.x** (everyone on the same minor version).
2. Open **`World.tscn`** and press **Play**.
3. Tweak exported vars in **`World.gd`**: `tex_size`, `quads_x/y`, `cell_size`, `height_scale`.

## Folder structure
```
World.tscn                     # main scene (Node3D + Camera3D + Light)
scripts/
  World.gd                     # orchestrates generation → mesh → material
  NoiseParams.gd               # seed, frequency, octaves, gain, lacunarity, sample_scale
  Heightmap.gd                 # builds grayscale Image via FastNoiseLite (Cellular+FBM)
  TerrainMeshBuilder.gd        # builds quad grid; UVs; samples 4 corner pixels (red)
ui/
  Tuner.tscn                   # (optional) sliders to tweak params
```
---

## Roles & individual responsibilities (7 people)

> Each person owns their file(s), opens PRs with proof screenshots, and ticks the rubric checks.

1) **Integrator / Mesh (Owner: _Name_)** — `scripts/TerrainMeshBuilder.gd`  
   - Build **1×1** quad (two triangles) with **UVs 0..1**.  
   - Extend to **2×2**, then parameterized **NxM** (`quads_x`, `quads_y`).  
   - Sample **4 corner pixels** (red channel) for heights; compute normals.  
   - ✅ Proof: wireframe + textured screenshots; show **no seams** at 2×2.

2) **Noise Image (Owner: _Name_)** — `scripts/Heightmap.gd`, `scripts/NoiseParams.gd`  
   - Generate **grayscale** image (r=g=b, a=1) using **FastNoiseLite.TYPE_CELLULAR** + **FRACTAL_FBM**.  
   - Expose **seed, frequency, octaves, gain, lacunarity, sample_scale**.  
   - ✅ Proof: image updates visibly when parameters change (screenshot or short clip).

3) **Texture & Seams (Owner: _Name_)** — material setup in `scripts/World.gd`  
   - Apply the **same image** as the mesh **albedo**.  
   - Force **NEAREST** filter (no blur; avoids seam artifacts).  
   - ✅ Proof: 2×2 close-up shows perfect alignment (no discontinuities).

4) **UI Tuner (Owner: _Name_)** — `ui/Tuner.tscn` (+ optional script)  
   - Add sliders (Seed / Frequency / Octaves / Gain / Lacunarity / HeightScale).  
   - On change: **regenerate image** and **rebuild mesh**.  
   - ✅ Proof: short clip showing live parameter tweak → geometry & texture update.

5) **Mask / Polish (Owner: _Name_)** — in `Heightmap.gd` or a simple material  
   - Option A: **Geometric columns** via a math mask (e.g., circle SDF + smoothstep).  
   - Option B: Height/slope gradient material (visual polish).  
   - ✅ Proof: toggle shows obvious different look (terrain vs columns, or polished shading).

6) **QA & Benchmarks (Owner: _Name_)** — add results to README  
   - Test `tex_size` in `{65, 129, 257}` and grids like `4×4`, `16×16`.  
   - Record **FPS** table and verify: UVs 0..1, red channel used, no seams at 2×2.  
   - ✅ Proof: table + 2–3 annotated screenshots (wireframe, textured, seam zoom).

7) **Docs & Videos (Owner: _Name_)** — this README + 2 clips  
   - Keep **this README** updated: how to run, roles, parameters, proof images.  
   - Capture **two short demo videos** and link them below.  
   - ✅ Proof: videos linked; board/log screenshot added.

---

## Contributing (team workflow)

- **One repo, one Godot project.** No personal forks/projects.  
- **Branch naming:** `feat/*`, `fix/*`, `docs/*` (e.g., `feat/mesh-grid`).  
- **PRs → `dev` branch**, ≤200 LOC when possible. 1 reviewer minimum.  
- **Include proof in every PR:**  
  - [ ] Wireframe screenshot  
  - [ ] Textured screenshot  
  - [ ] 2×2 seam close-up (if relevant)  
- **Do not push to `main`.** Integrator merges `dev → main` after green PRs.  
- **Godot settings:** everyone on **the same 4.x version**.

**Rubric checks (tick in PRs):**
- [ ] UVs 0..1  
- [ ] Heights from **red channel**; 4 corner samples per quad  
- [ ] **2×2** grid has **no seams**  
- [ ] Tests ≤ **256×256**  
- [ ] Texture matches heights (same image applied)

---

## “Seam rule” (important)
For a grid **Qx × Qy**, adjacent quads must sample the **same edge pixels**. We do this by mapping UVs to pixel indices with:  
```
px = round(u * (tex_size - 1))
py = round(v * (tex_size - 1))
```
…so both sides of a shared edge resolve to the same pixel.

---

## Parameters (cheat sheet)
- `seed`: deterministic variation of the noise field  
- `frequency`: feature size (lower → broad hills, higher → noisy detail)  
- `octaves`: number of FBM layers (3–6 typical)  
- `gain`: amplitude reduction per octave (~0.5)  
- `lacunarity`: frequency increase per octave (~2.0)  
- `sample_scale`: scales UV→noise coords (decouple look from `tex_size`)  
- `height_scale`: world-space height multiplier

---

## Demo videos (link here)
- **Video 1 (30–45s):** noise parameter tweaks → grayscale image changes  
- **Video 2 (45–60s):** 1×1 → 2×2 → NxM; wireframe + seam close-up; texture alignment  
Links:  
- Video 1: _TBD_  
- Video 2: _TBD_

---

## QA results (FPS & visuals)
_Add your table and screenshots here (by the QA owner)._  

| tex_size | quads_x×quads_y | FPS (avg) | Notes |
|---:|:---:|---:|---|
| 129 | 4×4 | 120 | no seams |
| 129 | 16×16 | 90 | OK |
| 257 | 16×16 | 60 | borderline on low-end laptop |

---

## Troubleshooting
- **Seams visible?** Ensure **NEAREST** filter on the material; no mipmaps on any imported textures; confirm the rounding formula above.  
- **Weird geometry?** Confirm you’re reading **`.r`** channel; image is locked before sampling.  
- **Slow builds?** Keep `tex_size` small while developing (65/129/257).  
- **Different looks across machines?** Verify everyone’s **Godot version** matches.

---

## Credits / Contributions
- _Name_ — Mesh / Integrator — PRs: #…  
- _Name_ — Noise Image — PRs: #…  
- _Name_ — Texture & Seams — PRs: #…  
- _Name_ — UI Tuner — PRs: #…  
- _Name_ — Mask / Polish — PRs: #…  
- _Name_ — QA & Bench — PRs: #…  
- _Name_ — Docs & Videos — PRs: #…
