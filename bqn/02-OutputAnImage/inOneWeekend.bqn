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

image_width ← 256
image_height ← 256

image ← > (⌽(image_height - 1)÷˜↕image_height) (⌽0.25∾⋈)⌜ (image_width - 1)÷˜↕image_width

ShowArray ⌊1000×image

"image.ppm" WritePPM image
