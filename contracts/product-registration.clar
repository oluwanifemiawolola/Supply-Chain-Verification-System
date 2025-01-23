;; Product Registration Contract

(define-data-var product-counter uint u0)

(define-map products uint {
  name: (string-ascii 100),
  manufacturer: principal,
  origin: (string-ascii 50),
  manufacture-date: uint,
  batch-id: (optional (string-ascii 50))
})

(define-public (register-product (name (string-ascii 100)) (origin (string-ascii 50)) (manufacture-date uint) (batch-id (optional (string-ascii 50))))
  (let
    ((new-id (+ (var-get product-counter) u1)))
    (map-set products new-id {
      name: name,
      manufacturer: tx-sender,
      origin: origin,
      manufacture-date: manufacture-date,
      batch-id: batch-id
    })
    (var-set product-counter new-id)
    (ok new-id)
  )
)

(define-read-only (get-product (product-id uint))
  (map-get? products product-id)
)

(define-read-only (get-product-count)
  (var-get product-counter)
)

