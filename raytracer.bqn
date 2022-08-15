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

HitSphere ⇐ {
  center‿radius‿r:
  origin‿direction ← (3⊸↑⋈3⊸↓) r
  oc ← origin - center
  a ← LengthSquared direction
  half_b ← ⊑ oc DotVV direction
  c ← (LengthSquared oc) - radius⋆2
  discriminant ← (half_b⋆2) - a × c
  #•Out (•Repr oc)∾", "∾(•Repr a)∾", "∾(•Repr b)∾", "∾(•Repr c)∾", "∾(•Repr discriminant)
  (discriminant < 0) ◶ ⟨(- half_b + √discriminant) ÷ a, ¯1⟩ @
  #(discriminant < 0) ◶ ⟨((-half_b) - √discriminant) ÷ a, ¯1⟩ @
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
