;; Verification Process Contract

(define-map verifications (tuple (product-id uint) (verifier principal)) {
  timestamp: uint,
  result: bool,
  notes: (string-utf8 500)
})

(define-public (verify-product (product-id uint) (result bool) (notes (string-utf8 500)))
  (ok (map-set verifications {product-id: product-id, verifier: tx-sender} {
    timestamp: block-height,
    result: result,
    notes: notes
  }))
)

(define-read-only (get-verification (product-id uint) (verifier principal))
  (map-get? verifications {product-id: product-id, verifier: verifier})
)

