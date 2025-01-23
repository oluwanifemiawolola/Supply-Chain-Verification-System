;; IoT Integration Contract

(define-constant CONTRACT_OWNER tx-sender)

(define-map authorized-devices principal bool)

(define-map iot-logs uint {
  product-id: uint,
  device-id: principal,
  timestamp: uint,
  temperature: int,
  humidity: int,
  location: (string-ascii 100)
})

(define-data-var log-counter uint u0)

(define-public (authorize-device (device principal))
  (begin
    (asserts! (is-eq tx-sender CONTRACT_OWNER) (err u403))
    (ok (map-set authorized-devices device true))
  )
)

(define-public (revoke-device (device principal))
  (begin
    (asserts! (is-eq tx-sender CONTRACT_OWNER) (err u403))
    (ok (map-set authorized-devices device false))
  )
)

(define-public (log-iot-data (product-id uint) (temperature int) (humidity int) (location (string-ascii 100)))
  (let
    ((new-id (+ (var-get log-counter) u1)))
    (asserts! (default-to false (map-get? authorized-devices tx-sender)) (err u403))
    (map-set iot-logs new-id {
      product-id: product-id,
      device-id: tx-sender,
      timestamp: block-height,
      temperature: temperature,
      humidity: humidity,
      location: location
    })
    (var-set log-counter new-id)
    (ok new-id)
  )
)

(define-read-only (get-iot-log (log-id uint))
  (map-get? iot-logs log-id)
)

(define-read-only (get-log-count)
  (var-get log-counter)
)

