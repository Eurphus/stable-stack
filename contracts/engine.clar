;;
;; Constants
;;
(define-constant err-no-interest (err u100))
(define-constant err-overpay (err u200))
(define-constant err-overborrow (err u300))
(define-constant LIQUIDATION_THRESHOLD 200)
(define-constant LIQUIDATION_BONUS 10)
(define-constant LIQUIDATION_PRECISION 100)
(define-constant MIN_HEALTH_FACTOR 1000000000000000000)
(define-constant PRECISION 1000000000000000000)
(define-constant ADDITIONAL_FEED_PRECISION 10000000000)
(define-constant FEED_PRECISION 100000000)

;;
;; Variables
;;

(define-map deposits { owner: principal } { amount: uint })
