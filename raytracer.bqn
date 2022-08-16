Dot ⇐ {
  1≡⊑≠𝕨? ≍+´ (⥊𝕨) × <˘ 𝕩;
  1≡1⊑≢𝕩? (≠𝕨)‿1⥊ (+´(⥊𝕩)⊸×)˘𝕨;
  𝕨 +˝∘×⎉1‿∞ 𝕩
}

DotVV ⇐ {
  𝕨 +˝∘×⎉1‿∞ 𝕩
}

LengthSquared ⇐ {
  ⊑ +´∘⋆⟜2𝕩
}

Length ⇐ {
  √ LengthSquared 𝕩
}

Unit ⇐ (⊢÷Length)

SetFaceNormal ← {
  r‿outward_normal:
  origin‿direction ← (3⊸↑⋈3⊸↓) r
  #•Show ⊑ direction DotVV outward_normal
  front_face ← 0 > ⊑ direction DotVV outward_normal
  normal ← front_face ⊑ (-outward_normal)‿outward_normal
  #normal ← front_face ⊑ (outward_normal)‿(-outward_normal)
  #•Show normal
  normal‿front_face
}

HitSphere ⇐ {
  center‿radius‿r‿t_min‿t_max:
  origin‿direction ← (3⊸↑⋈3⊸↓) r
  rec ← {
    p ⇐ @  # 3
    normal ⇐ @  # 3
    t ⇐ @  # double
    front_face ⇐ @  # bool
  }
  oc ← origin - center
  a ← LengthSquared direction
  half_b ← ⊑ oc DotVV direction
  c ← (LengthSquared oc) - radius⋆2
  discriminant ← (half_b⋆2) - a × c
  #•Out (•Repr oc)∾", "∾(•Repr a)∾", "∾(•Repr b)∾", "∾(•Repr c)∾", "∾(•Repr discriminant)
  (discriminant < 0) ◶ ⟨
    {𝕤
      sqrtd ← √discriminant
      root ← ((-half_b) - sqrtd) ÷ a
      ⟨
        root ↩ ((-half_b) + sqrtd) ÷ a
      ⟩ ⍟ ((root < t_min) ∨ (root > t_max)) @
      ((root < t_min) ∨ (root > t_max)) ◶ ⟨
        {𝕤
          rec ↩ {
            t ⇐ root
            p ⇐ r RayAt t
            outward_normal ← (p - center) ÷ radius
            #normal‿front_face ← SetFaceNormal r‿outward_normal
            nm‿ff ← SetFaceNormal r‿outward_normal
            normal ⇐ nm
            front_face ⇐ ff
          }
          1‿rec
        }
        {𝕤
          0‿rec
        }
      ⟩ @
    }
    {𝕤
      0‿rec
    }
  ⟩ @
  #(discriminant < 0) ◶ ⟨((-half_b) - √discriminant) ÷ a, ¯1⟩ @
}

WorldHit ⇐ {
  world‿r‿t_min‿t_max:
  rec ← {
    p ⇐ @  # 3
    normal ⇐ @  # 3
    t ⇐ @  # double
    front_face ⇐ @  # bool
  }
  hit_anything ← 0
  closest_so_far ← t_max
  {
    center‿radius:
    #•Show center‿radius
    hit‿temp_rec ← HitSphere center‿radius‿r‿t_min‿closest_so_far
    {𝕤
      hit_anything ↩ 1
      closest_so_far ↩ temp_rec.t
      rec ↩ temp_rec
    } ⍟ (hit) @
  }¨ world.spheres
  hit_anything‿rec
}

RayAt ⇐ {
  r 𝕊 t:
  origin‿direction ← (3⊸↑⋈3⊸↓) r
  origin + direction × t
}

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
