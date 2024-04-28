;;
;; Constants
;;
(define-constant SUSDEngine__TokenAddressesAndPriceFeedAddressesAmountsDontMatch u0)
(define-constant SUSDEngine__NeedsMoreThanZero u1)
(define-constant SUSDEngine__TokenNotAllowed u2)
(define-constant SUSDEngine__TransferFailed u3)
(define-constant SUSDEngine__BreaksHealthFactoru u4)
(define-constant SUSDEngine__MintFailed u5)
(define-constant SUSDEngine__HealthFactorOk u6)
(define-constant SUSDEngine__HealthFactorNotImproved u7)
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
(define-map price-feed { collateralToken: principal} { amount: uint })
(define-map deposits { owner: principal } { amount: uint })
(define-map loans principal { amount: uint, last-interaction-blocl: uint })
(define-map minted principal { amount: uint })
(define-map collateralDeposited { owner: principal } 
                                { collateralToken: principal, amount: uint })

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;  Public Functions                 ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Takes sBTC as collateral, and mints SUSD 
;; (define-public (depositCollateralAndMintSUSD (address principal) (amountCollateral uint) (amountToMint uint))
;;  (depositCollateral address amountCollateral)
;;  (mintSUSD amountToMint))

(define-public (mintSUSD (amount uint))
  ;; assert here
  (ok ":D")
  )

(define-public (depositCollateral (address principal) (amountCollateral uint))
  ;;(asserts! true false) ;; Being Weird, FIX later
  ;; asset check if allow token
  ;;(let ((ma val-1)) )
  (let ((currentAmount (map-get? collateralDeposited address))) expr-1)
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;  Private Functions                ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define-private (redeemCollateral (address principal) (amountCollateral uint)
                                  (from principal) (to principal)) 
  (ok ":D"))

(define-private (burnSUSD (amount uint) (onBehalfOf principal) (from principal))
  (ok ":D"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;  Private, Internal Functs         ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

