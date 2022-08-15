rt ← •Import "raytracer.bqn"

# image
aspect_ratio ← 16 ÷ 9
image_width ← 400
image_height ← ⌊ image_width ÷ aspect_ratio

# camera
viewport_height ← 2
viewport_width ← aspect_ratio × viewport_height
focal_length ← 1

origin ← 0‿0‿0
horizontal ← viewport_width‿0‿0
vertical ← 0‿viewport_height‿0
lower_left_corner ← origin + (-horizontal ÷ 2) + (-vertical ÷ 2) + -0‿0‿focal_length

# render
im ← ⌽⎉1 > (⌽(↕÷-⟜1) image_height) (0⊸∾⋈)⌜ ((↕÷-⟜1) image_width)
vp ← {-⟜origin lower_left_corner + viewport_width‿viewport_height‿1 × 𝕩} ⎉1 im

#Dot ← {
#  1≡⊑≠𝕨? ≍+´ (⥊𝕨) × <˘ 𝕩;
#  1≡1⊑≢𝕩? (≠𝕨)‿1⥊ (+´(⥊𝕩)⊸×)˘𝕨;
#  𝕨 +˝∘×⎉1‿∞ 𝕩
#}

Dot ← {
  1≡⊑≠𝕨? ≍+´ (⥊𝕨) × <˘ 𝕩;
  1≡1⊑≢𝕩? (≠𝕨)‿1⥊ (+´(⥊𝕩)⊸×)˘𝕨;
  𝕨 +˝∘×⎉1‿∞ 𝕩
}

DotVV ← {
  𝕨 +˝∘×⎉1‿∞ 𝕩
}

HitSphere ← {
  center‿radius‿r:
  origin ← 3↑r
  direction ← 3↓r
  oc ← origin - center
  a ← ⊑ direction DotVV direction
  b ← ⊑ 2 × oc DotVV direction
  c ← (⊑ oc DotVV oc) - radius × radius
  discriminant ← (b × b) - 4 × a × c
  #•Out (•Repr oc)∾", "∾(•Repr a)∾", "∾(•Repr b)∾", "∾(•Repr c)∾", "∾(•Repr discriminant)
  (discriminant < 0) ◶ ⟨((-b) - √discriminant) ÷ 2 × a, ¯1⟩ @
}

RayAt ← {
  r 𝕊 t:
  origin ← 3↑r
  direction ← 3↓r
  origin + direction × t
}

ColorRay ← {
  𝕊 r:
  t ← HitSphere ⟨0, 0, ¯1⟩‿0.5‿r
  (t > 0) ◶ ⟨
    {𝕤
      t ← 0.5 × 1 + 1⊑ rt.Unit r
      c ← (1‿1‿1 × 1 - t) + 0.5‿0.7‿1.0 × t
      c
    }
    {𝕤
      n ← rt.Unit (r RayAt t) - 0‿0‿¯1
      c ← 0.5 × n + 1
      c
    }
  ⟩ @
}

rs ← origin⊸∾ ⎉1 vp
cs ← ColorRay⎉1 rs

"blue.ppm" rt.WritePPM cs
