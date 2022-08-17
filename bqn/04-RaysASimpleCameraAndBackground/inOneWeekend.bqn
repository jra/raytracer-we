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

LengthSquared ← {
  +´ 𝕩 × 𝕩
}

Length ← {
  √ LengthSquared 𝕩
}

UnitVector ← {
  𝕩 ÷ Length 𝕩
}

RayColor ← {
  𝕊 r:
  origin‿direction ← (3⊸↑⋈3⊸↓) r
  unit_direction ← UnitVector direction
  t ← 0.5 × (1⊑unit_direction) + 1
  ((1 - t) × 1‿1‿1) + t × 0.5‿0.7‿1
}

# Image

aspect_ratio ← 16.0 ÷ 9.0
image_width ← 400
image_height ← image_width ÷ aspect_ratio

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
image ← RayColor ⎉1 rays

#ShowArray ⌊1000×image
#ShowArray image

"image.ppm" WritePPM image
