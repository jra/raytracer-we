# https://raytracing.github.io/books/RayTracingInOneWeekend.html

WritePPM ⇐ {
  # ar is nrows×ncols×3 array, final axis is rgb, floats in [0,1]
  path 𝕊 a:
  nrows‿ncols ← 2↑≢a
  path •file.Lines ⟨
    "P3"
    (•Fmt ncols)∾" "∾(•Fmt nrows)
    (•Fmt 255)
  ⟩ ∾ ⥊ (⊣∾" "⊸∾)´¨ <⎉1 •Fmt¨ ⌊255.999×a
}

ShowArray ← {
  𝕊 a:
  FirstLast3 ← {
    𝕊 b:
    FmtSpc ← {
      𝕊 c:
      (•Fmt c)∾" "
    }
    •Out (∾ FmtSpc¨ <˘3↑b)∾"... "∾(∾ FmtSpc¨ <˘¯3↑b)
  }
  FirstLast3¨ <˘3↑a
  •Out⍟3 "."
  FirstLast3¨ <˘¯3↑a
}

LengthSquared ← +´⋆⟜2

Length ← √LengthSquared

UnitVector ← ÷⟜Length

DotVV ⇐ {
  𝕨 +˝∘×⎉1‿∞ 𝕩
}

RayAt ⇐ {
  r 𝕊 t:
  origin‿direction ← (3⊸↑⋈3⊸↓) r
  origin + direction × t
}

SetFaceNormal ← {
  r‿outward_normal:
  origin‿direction ← (3⊸↑⋈3⊸↓) r
  front_face ← (⊑ direction DotVV outward_normal) < 0
  normal ← front_face ⊑ ⟨
    - outward_normal
    outward_normal
  ⟩
  normal‿front_face
}

HitSphere ← {
  center‿radius‿r‿t_min‿t_max:
  origin‿direction ← (3⊸↑⋈3⊸↓) r
  hit ← 0
  rec ← @
  oc ← origin - center
  a ← LengthSquared direction
  half_b ← ⊑ oc DotVV direction
  c ← (LengthSquared oc) - radius × radius
  discriminant ← ⊑ (half_b × half_b) - a × c
  •Out (•Repr r)∾", "∾(•Repr oc)∾", "∾(•Repr a)∾", "∾(•Repr half_b)∾", "∾(•Repr c)∾", "∾(•Repr discriminant)
  {𝕤
    sqrtd ← √discriminant
    root ← ((-half_b) - sqrtd) ÷ a
    •Out (•Repr sqrtd)∾", "
    •Out (•Repr root)∾", "
    RootBad ← { (𝕩 < t_min) ∨ (𝕩 > t_max) }
    (RootBad root) ◶ ⟨
      {𝕤
        hit ↩ 1
      }
      {𝕤
        root ↩ ((-half_b) + sqrtd) ÷ a
        •Out (•Repr root)∾", "
        {𝕤
          hit ↩ 1
        } ⍟ (¬ RootBad root) @
      }
    ⟩ @
    rec ↩ hit ⊑ ⟨
      @
      {
        t ⇐ root
        p ⇐ r RayAt t
        outward_normal ← (p - center) ÷ radius
        normal‿front_face ⇐ SetFaceNormal r‿outward_normal
      }
    ⟩
  } ⍟ (discriminant ≥ 0) @
  hit‿rec
}

WorldHit ⇐ {
  world 𝕊 r‿t_min‿t_max:
  rec ← @
  hit_anything ← 0
  closest_so_far ← t_max
  {
    center‿radius:
    hit‿temp_rec ← HitSphere center‿radius‿r‿t_min‿closest_so_far
    {𝕤
      hit_anything ↩ 1
      closest_so_far ↩ temp_rec.t
      rec ↩ temp_rec
    } ⍟ hit @
  }¨ world.spheres
  hit_anything‿rec
}

RayColor ← {
  world 𝕊 r:
  hit‿rec ← world WorldHit r‿0‿∞
  hit ◶ ⟨
    {𝕤
      origin‿direction ← (3⊸↑⋈3⊸↓) r
      unit_direction ← UnitVector direction
      t ← 0.5 × (1⊑unit_direction) + 1
      ((1 - t) × 1‿1‿1) + t × 0.5‿0.7‿1
    }
    {𝕤
      0.5 × rec.normal + 1‿1‿1
    }
  ⟩ @
}

# Image

aspect_ratio ← 16.0 ÷ 9.0
image_width ← 400
image_height ← image_width ÷ aspect_ratio

# World

world ← {
  spheres ⇐ ⟨
    ⟨0‿0‿¯1, 0.5⟩
    ⟨0‿¯100.5‿¯1, 100⟩
  ⟩
}

# Camera

viewport_height ← 2.0
viewport_width ← aspect_ratio × viewport_height
focal_length ← 1.0

origin ← 0‿0‿0
horizontal ← viewport_width‿0‿0
vertical ← 0‿viewport_height‿0
lower_left_corner ← origin - (horizontal÷2) + (vertical÷2) + 0‿0‿focal_length

# Render

ijs ← > (⌽↕image_height) (⌽⋈)⌜ (↕image_width)
uvs ← ⟨image_width - 1, image_height - 1⟩ ÷˜⎉1 ijs
rays ← {
  u‿v:
  origin ∾ lower_left_corner + (u × horizontal) + (v × vertical) - origin
} ⎉1 uvs
image ← { world RayColor 𝕩 } ⎉1 rays

#ShowArray ⌊1000×image
#ShowArray image

"image.ppm" WritePPM image
