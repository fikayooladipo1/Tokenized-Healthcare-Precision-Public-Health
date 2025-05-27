;; Population Verification Contract
;; Validates and manages health populations

(define-constant contract-owner tx-sender)
(define-constant err-owner-only (err u100))
(define-constant err-not-found (err u101))
(define-constant err-already-exists (err u102))
(define-constant err-invalid-data (err u103))

;; Population data structure
(define-map populations
  { population-id: uint }
  {
    name: (string-ascii 50),
    size: uint,
    verified: bool,
    created-at: uint,
    updated-at: uint
  }
)

;; Population member verification
(define-map population-members
  { population-id: uint, member-id: principal }
  {
    verified: bool,
    risk-score: uint,
    last-updated: uint
  }
)

(define-data-var next-population-id uint u1)

;; Create new population
(define-public (create-population (name (string-ascii 50)) (initial-size uint))
  (let ((population-id (var-get next-population-id)))
    (asserts! (is-eq tx-sender contract-owner) err-owner-only)
    (asserts! (> (len name) u0) err-invalid-data)

    (map-set populations
      { population-id: population-id }
      {
        name: name,
        size: initial-size,
        verified: false,
        created-at: block-height,
        updated-at: block-height
      }
    )

    (var-set next-population-id (+ population-id u1))
    (ok population-id)
  )
)

;; Verify population
(define-public (verify-population (population-id uint))
  (let ((population (unwrap! (map-get? populations { population-id: population-id }) err-not-found)))
    (asserts! (is-eq tx-sender contract-owner) err-owner-only)

    (map-set populations
      { population-id: population-id }
      (merge population { verified: true, updated-at: block-height })
    )
    (ok true)
  )
)

;; Add member to population
(define-public (add-member (population-id uint) (member-id principal))
  (let ((population (unwrap! (map-get? populations { population-id: population-id }) err-not-found)))
    (asserts! (is-eq tx-sender contract-owner) err-owner-only)
    (asserts! (get verified population) err-invalid-data)

    (map-set population-members
      { population-id: population-id, member-id: member-id }
      {
        verified: true,
        risk-score: u0,
        last-updated: block-height
      }
    )
    (ok true)
  )
)

;; Get population info
(define-read-only (get-population (population-id uint))
  (map-get? populations { population-id: population-id })
)

;; Get member info
(define-read-only (get-member (population-id uint) (member-id principal))
  (map-get? population-members { population-id: population-id, member-id: member-id })
)

;; Check if member is verified
(define-read-only (is-member-verified (population-id uint) (member-id principal))
  (match (map-get? population-members { population-id: population-id, member-id: member-id })
    member (get verified member)
    false
  )
)
