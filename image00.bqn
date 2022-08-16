rt ← •Import "raytracer.bqn"

# image
aspect_ratio ← 16 ÷ 9
image_width ← 400
image_height ← ⌊ image_width ÷ aspect_ratio
#samples_per_pixel ← 100
samples_per_pixel ← 3

# world
world ← {
  spheres ⇐ ⟨
    ⟨0‿0‿¯1, 0.5⟩
    ⟨0‿¯100.5‿¯1, 100⟩
  ⟩
}

# camera
viewport_height ← 2
viewport_width ← aspect_ratio × viewport_height
focal_length ← 1

origin ← 0‿0‿0
horizontal ← viewport_width‿0‿0
vertical ← 0‿viewport_height‿0
lower_left_corner ← origin + (-horizontal ÷ 2) + (-vertical ÷ 2) + -0‿0‿focal_length

GetRay ← {
  𝕊 uv:
  origin∾{-⟜origin lower_left_corner + viewport_width‿viewport_height‿1 × uv∾0}
}

# render
ijs ← > (⌽↕image_height) (⌽⋈)⌜ (↕image_width)
•Show ≢ ijs
rng ← •MakeRand 0
uvs ← ⟨image_width - 1, image_height - 1⟩ ÷˜⎉1 ijs +⎉1 image_height‿image_width‿samples_per_pixel‿2 rng.Range 0
•Show ≢ uvs

rs ← GetRay ⎉1 uvs
•Show ≢ rs

ColorRay ← {
  world 𝕊 r:
  hit‿rec ← rt.WorldHit world‿r‿0‿∞
  hit ◶ ⟨
    {𝕤
      origin‿direction ← (3⊸↑⋈3⊸↓) r
      t ← 0.5 × 1 + 1⊑ rt.Unit direction
      c ← (1‿1‿1 × 1 - t) + 0.5‿0.7‿1.0 × t
      c
    }
    {𝕤
      #•Show rec.normal
      c ← 0.5 × rec.normal + 1
      c
    }
  ⟩ @
}

cs ← world⊸ColorRay ⎉1 rs
•Show ≢ cs
cs ↩ (+˝÷≠)⎉2 cs
•Show ≢ cs

"blue.ppm" rt.WritePPM cs
