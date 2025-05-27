;; Resource Allocation Contract
;; Optimizes public health investments

(define-constant contract-owner tx-sender)
(define-constant err-owner-only (err u500))
(define-constant err-not-found (err u501))
(define-constant err-insufficient-budget (err u502))
(define-constant err-invalid-allocation (err u503))

;; Budget tracking
(define-map budget-pools
  { pool-id: uint }
  {
    name: (string-ascii 50),
    total-budget: uint,
    allocated: uint,
    spent: uint,
    remaining: uint,
    active: bool
  }
)

;; Resource allocations
(define-map allocations
  { allocation-id: uint }
  {
    pool-id: uint,
    intervention-id: uint,
    population-id: uint,
    amount: uint,
    priority-score: uint,
    approved: bool,
    allocated-at: uint
  }
)

;; Efficiency tracking
(define-map efficiency-metrics
  { intervention-id: uint, population-id: uint }
  {
    cost-per-outcome: uint,
    effectiveness-score: uint,
    roi-percentage: uint,
    last-calculated: uint
  }
)

(define-data-var next-pool-id uint u1)
(define-data-var next-allocation-id uint u1)

;; Create budget pool
(define-public (create-budget-pool (name (string-ascii 50)) (total-budget uint))
  (let ((pool-id (var-get next-pool-id)))
    (asserts! (is-eq tx-sender contract-owner) err-owner-only)
    (asserts! (> (len name) u0) err-invalid-allocation)
    (asserts! (> total-budget u0) err-invalid-allocation)

    (map-set budget-pools
      { pool-id: pool-id }
      {
        name: name,
        total-budget: total-budget,
        allocated: u0,
        spent: u0,
        remaining: total-budget,
        active: true
      }
    )

    (var-set next-pool-id (+ pool-id u1))
    (ok pool-id)
  )
)

;; Allocate resources
(define-public (allocate-resources (pool-id uint) (intervention-id uint) (population-id uint) (amount uint) (priority-score uint))
  (let (
    (pool (unwrap! (map-get? budget-pools { pool-id: pool-id }) err-not-found))
    (allocation-id (var-get next-allocation-id))
  )
    (asserts! (is-eq tx-sender contract-owner) err-owner-only)
    (asserts! (get active pool) err-invalid-allocation)
    (asserts! (<= amount (get remaining pool)) err-insufficient-budget)

    ;; Update budget pool
    (map-set budget-pools
      { pool-id: pool-id }
      (merge pool {
        allocated: (+ (get allocated pool) amount),
        remaining: (- (get remaining pool) amount)
      })
    )

    ;; Create allocation record
    (map-set allocations
      { allocation-id: allocation-id }
      {
        pool-id: pool-id,
        intervention-id: intervention-id,
        population-id: population-id,
        amount: amount,
        priority-score: priority-score,
        approved: true,
        allocated-at: block-height
      }
    )

    (var-set next-allocation-id (+ allocation-id u1))
    (ok allocation-id)
  )
)

;; Record spending
(define-public (record-spending (pool-id uint) (amount uint))
  (let ((pool (unwrap! (map-get? budget-pools { pool-id: pool-id }) err-not-found)))
    (asserts! (is-eq tx-sender contract-owner) err-owner-only)
    (asserts! (<= amount (get allocated pool)) err-insufficient-budget)

    (map-set budget-pools
      { pool-id: pool-id }
      (merge pool {
        spent: (+ (get spent pool) amount)
      })
    )
    (ok true)
  )
)

;; Calculate efficiency metrics
(define-public (calculate-efficiency (intervention-id uint) (population-id uint) (total-cost uint) (total-outcomes uint) (effectiveness uint))
  (let (
    (cost-per-outcome (if (> total-outcomes u0) (/ total-cost total-outcomes) u0))
    (roi (if (> total-cost u0) (/ (* effectiveness u100) total-cost) u0))
  )
    (asserts! (is-eq tx-sender contract-owner) err-owner-only)

    (map-set efficiency-metrics
      { intervention-id: intervention-id, population-id: population-id }
      {
        cost-per-outcome: cost-per-outcome,
        effectiveness-score: effectiveness,
        roi-percentage: roi,
        last-calculated: block-height
      }
    )
    (ok roi)
  )
)

;; Get budget pool
(define-read-only (get-budget-pool (pool-id uint))
  (map-get? budget-pools { pool-id: pool-id })
)

;; Get allocation
(define-read-only (get-allocation (allocation-id uint))
  (map-get? allocations { allocation-id: allocation-id })
)

;; Get efficiency metrics
(define-read-only (get-efficiency (intervention-id uint) (population-id uint))
  (map-get? efficiency-metrics { intervention-id: intervention-id, population-id: population-id })
)

;; Check budget availability
(define-read-only (check-budget-availability (pool-id uint) (amount uint))
  (match (map-get? budget-pools { pool-id: pool-id })
    pool (>= (get remaining pool) amount)
    false
  )
)
