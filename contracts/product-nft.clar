;; Product NFT Contract

(define-non-fungible-token product-nft uint)

(define-data-var token-id-counter uint u0)

(define-map token-metadata uint {
  product-id: uint,
  name: (string-ascii 100),
  manufacturer: principal,
  origin: (string-ascii 50),
  manufacture-date: uint,
  current-owner: principal
})

(define-public (mint-product-nft (product-id uint) (name (string-ascii 100)) (origin (string-ascii 50)) (manufacture-date uint))
  (let
    ((new-id (+ (var-get token-id-counter) u1)))
    (try! (nft-mint? product-nft new-id tx-sender))
    (map-set token-metadata new-id {
      product-id: product-id,
      name: name,
      manufacturer: tx-sender,
      origin: origin,
      manufacture-date: manufacture-date,
      current-owner: tx-sender
    })
    (var-set token-id-counter new-id)
    (ok new-id)
  )
)

(define-public (transfer (token-id uint) (sender principal) (recipient principal))
  (begin
    (asserts! (is-eq tx-sender sender) (err u403))
    (try! (nft-transfer? product-nft token-id sender recipient))
    (ok (map-set token-metadata token-id
      (merge (unwrap! (map-get? token-metadata token-id) (err u404))
        { current-owner: recipient })))
  )
)

(define-read-only (get-token-metadata (token-id uint))
  (map-get? token-metadata token-id)
)

(define-read-only (get-last-token-id)
  (var-get token-id-counter)
)

