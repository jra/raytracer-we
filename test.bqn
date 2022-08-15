rt ← •Import "raytracer.bqn"

#a ← 2‿3‿3⥊1‿0‿0‿0‿1‿0‿0‿0‿1‿1‿1‿0‿1‿1‿1‿0‿0‿0
a ← [
  [1‿0‿0, 0‿1‿0, 0‿0‿1]
  [1‿1‿0, 1‿1‿1, 0‿0‿0]
]

#•Show ≢a
#•Show a
#•Show ∾⟜" "∘•Fmt¨⎉2 ⌊255×a
#•Show <⎉1∾⟜" "∘•Fmt¨⎉2 ⌊255×a
#•Show ∾¨<⎉1∾⟜" "∘•Fmt¨⎉2 ⌊255×a
#•Show ¯1↓¨∾¨<⎉1∾⟜" "∘•Fmt¨⎉2 ⌊255×a
#•Show ⥊¯1↓¨∾¨<⎉1∾⟜" "∘•Fmt¨⎉2 ⌊255×a
"a.ppm" rt.WritePPM a

nrows_b ← 256
ncols_b ← 256
b ← 256‿256‿3 ⥊ ∾ ⥊ ⍉ ∾⟜0.25¨ ((nrows_b-1)÷˜↕nrows_b) ∾⌜ (⌽(ncols_b-1)÷˜↕ncols_b)

#•Show 0 ⊏ b

"b.ppm" rt.WritePPM b

! (√3) = rt.Length 1‿1‿1
! (√12) = rt.Length 2‿2‿2
! (√14) = rt.Length 1‿2‿3

! 1 = rt.Length rt.Unit 1‿1‿1
! 1 = rt.Length rt.Unit 2‿2‿2
! 1 = rt.Length rt.Unit 1‿2‿3
