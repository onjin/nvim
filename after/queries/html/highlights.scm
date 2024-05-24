;; extends

;((attribute
;   (attribute_name) @att_name (#eq? @att_name "class")
;   (quoted_attribute_value (attribute_value) @att_val) (#set! conceal "…")
;   ))
((attribute
   (attribute_name) @att_name (#eq? @att_name "class")
   (quoted_attribute_value (attribute_value) @class_value) (#set! @class_value conceal "…")))
