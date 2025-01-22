;; ClarityMarket: Decentralized Digital Marketplacet
;; ClarityMarket enables seamless listing, trading, and management of 
;; digital assets with automated fee processing and ownership tracking.

;; Constants
(define-constant contract-owner tx-sender)
(define-constant fee-rate u25) ;; 2.5% fee

;; Error codes
(define-constant err-not-authorized (err u1))
(define-constant err-item-not-found (err u2))
(define-constant err-already-sold (err u3))
(define-constant err-wrong-price (err u4))

;; Data structures
(define-map items 
    {item-id: uint} 
    {
        owner: principal,
        price: uint,
        description: (string-ascii 50),
        is-sold: bool
    }
)

;; Data variables
(define-data-var next-item-id uint u0)
(define-data-var market-volume uint u0)

;; Helper function to calculate fee
(define-private (calculate-fee (price uint))
    (/ (* price fee-rate) u1000)
)

;; Read functions
(define-read-only (get-item (item-id uint))
    (map-get? items {item-id: item-id})
)

(define-read-only (get-market-volume)
    (var-get market-volume)
)

;; List item for sale - First interaction with marketplace
(define-public (list-item (price uint) (description (string-ascii 50)))
    (let
        (
            (item-id (var-get next-item-id))
        )
        (map-set items
            {item-id: item-id}
            {
                owner: tx-sender,
                price: price,
                description: description,
                is-sold: false
            }
        )
        (var-set next-item-id (+ item-id u1))
        (ok item-id)
    )
)

;; Update item price - Modify existing listing
(define-public (update-price (item-id uint) (new-price uint))
    (let
        (
            (item (unwrap! (get-item item-id) err-item-not-found))
        )
        ;; Check ownership
        (asserts! (is-eq tx-sender (get owner item)) err-not-authorized)
        ;; Check if not sold
        (asserts! (not (get is-sold item)) err-already-sold)
        
        ;; Update price
        (map-set items
            {item-id: item-id}
            (merge item {price: new-price})
        )
        (ok true)
    )
)

;; Cancel listing - Remove from marketplace
(define-public (cancel-listing (item-id uint))
    (let
        (
            (item (unwrap! (get-item item-id) err-item-not-found))
        )
        ;; Check ownership
        (asserts! (is-eq tx-sender (get owner item)) err-not-authorized)
        ;; Check if not sold
        (asserts! (not (get is-sold item)) err-already-sold)
        
        ;; Remove listing
        (map-delete items {item-id: item-id})
        (ok true)
    )
)

;; Buy item - Final marketplace interaction
(define-public (buy-item (item-id uint))
    (let
        (
            (item (unwrap! (get-item item-id) err-item-not-found))
            (price (get price item))
            (seller (get owner item))
            (fee (calculate-fee price))
            (seller-amount (- price fee))
        )
        ;; Checks
        (asserts! (not (get is-sold item)) err-already-sold)
        
        ;; Process payments
        (try! (stx-transfer? price tx-sender seller))
        (try! (stx-transfer? fee tx-sender contract-owner))
        
        ;; Update item status
        (map-set items
            {item-id: item-id}
            (merge item {
                owner: tx-sender,
                is-sold: true
            })
        )
        
        ;; Update market volume
        (var-set market-volume (+ (var-get market-volume) price))
        
        (ok true)
    )
)