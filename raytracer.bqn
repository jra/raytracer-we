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

Length ⇐ {
  √+´∘⋆⟜2𝕩
}

Unit ⇐ (⊢÷Length)
#Unit ← {
#  𝕩 ÷ Length 𝕩
#}
