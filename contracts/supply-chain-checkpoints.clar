;; Supply Chain Checkpoints Contract

(define-data-var checkpoint-counter uint u0)

(define-map checkpoints uint {
  product-id: uint,
  location: (string-ascii 100),
  timestamp: uint,
  handler: principal,
  condition: (string-ascii 50)
})

(define-public (log-checkpoint (product-id uint) (location (string-ascii 100)) (condition (string-ascii 50)))
  (let
    ((new-id (+ (var-get checkpoint-counter) u1)))
    (map-set checkpoints new-id {
      product-id: product-id,
      location: location,
      timestamp: block-height,
      handler: tx-sender,
      condition: condition
    })
    (var-set checkpoint-counter new-id)
    (ok new-id)
  )
)

(define-read-only (get-checkpoint (checkpoint-id uint))
  (map-get? checkpoints checkpoint-id)
)

(define-read-only (get-checkpoint-count)
  (var-get checkpoint-counter)
)

