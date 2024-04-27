(define-read-only LIQUIDATION_THRESHOLD (uint))
(define-read-only LIQUIDATION_BONUS (uint))
(define-read-only LIQUIDATION_PRECISION (uint))
(define-read-only MIN_HEALTH_FACTOR (uint))
(define-read-only PRECISION (uint))
(define-read-only ADDITIONAL_FEED_PRECISION (uint))
(define-read-only FEED_PRECISION (uint))

(define-private i_susd (contract DecentralizedStableCoin))

(define-private s_priceFeeds (map address address)) 
(define-private s_collateralDeposited (map address (map address uint))) 
(define-private s_SUSDMinted (map address uint)) 
(define-private s_collateralTokens (list address)) 

;; (event (CollateralDeposited (user address) (token address) (amount unit)))
;; (event (CollateralRedeemed (redeemFrom address) (redeemTo address) (token address) (amount uint)))

(define-constant SUSDEngine__TokenAddressesAndPriceFeedAddressesAmountsDontMatch u0)
(define-constant SUSDEngine__NeedsMoreThanZero u1)
(define-constant SUSDEngine__TokenNotAllowed u2)
(define-constant SUSDEngine__TransferFailed u3)
(define-constant SUSDEngine__BreaksHealthFactoru u4)
(define-constant SUSDEngine__MintFailed u5)
(define-constant SUSDEngine__HealthFactorOk u6)
(define-constant SUSDEngine__HealthFactorNotImproved u7)

(define-read-only moreThanZero (fun (amount uint) (if (is-eq amount u0) (err SUSDEngine__NeedsMoreThanZero) (ok))))
(define-read-only isAllowedToken (fun (token address) (if (not (get s_priceFeeds token)) (err SUSDEngine__TokenNotAllowed token) (ok))))

(define-private (constructor (tokenAddresses (list address)) (priceFeedAddresses (list address)) (susdAddress address))
  (if (not (len tokenAddresses) (len priceFeedAddresses)) (err SUSDEngine__TokenAddressesAndPriceFeedAddressesAmountsDontMatch) (ok))
  (for (map tokenAddresses priceFeedAddresses) (pair (token address) (priceFeed address))
    (set s_priceFeeds token priceFeed)
    (set s_collateralTokens (append s_collateralTokens (list token)))
  )
  (set i_susd (contract-call susdAddress "DecentralizedStableCoin")))
  
(define-public (depositCollateralAndMintSUSD (tokenCollateralAddress address) (amountCollateral uint) (amountSUSDToMint uint))
  (depositCollateral tokenCollateralAddress amountCollateral)
  (mintSUSD amountSUSDToMint))
  
(define-public (redeemCollateralForSUSD (tokenCollateralAddress address) (amountCollateral uint) (amountSUSDToBurn uint))
  (assert (moreThanZero amountCollateral))
  (assert (isAllowedToken tokenCollateralAddress))
  (burnSUSD amountSUSDToBurn (tx-sender) (tx-sender))
  (redeemCollateral tokenCollateralAddress amountCollateral (tx-sender) (tx-sender))
  (if (< (healthFactor (tx-sender)) MIN_HEALTH_FACTOR) (revert SUSDEngine__BreaksHealthFactor (healthFactor (tx-sender))) (ok)))
  
(define-public (redeemCollateral (tokenCollateralAddress address) (amountCollateral uint))
  (assert (moreThanZero amountCollateral))
  (assert (isAllowedToken tokenCollateralAddress))
  (redeemCollateral tokenCollateralAddress amountCollateral (tx-sender) (tx-sender))
  (if (< (healthFactor (tx-sender)) MIN_HEALTH_FACTOR) (revert SUSDEngine__BreaksHealthFactor (healthFactor (tx-sender))) (ok)))
  
(define-public (burnSUSD (amount uint))
  (assert (moreThanZero amount))
  (burnSUSD amount (tx-sender) (tx-sender))
  (if (< (healthFactor (tx-sender)) MIN_HEALTH_FACTOR) (revert SUSDEngine__BreaksHealthFactor (healthFactor (tx-sender))) (ok)))
  
(define-public (liquidate (collateral address) (user address) (debtToCover uint))
  (assert (moreThanZero debtToCover))
  (let ((startingUserHealthFactor (healthFactor user)))
    (if (>= startingUserHealthFactor MIN_HEALTH_FACTOR) (revert SUSDEngine__HealthFactorOk) (ok))
    (let ((tokenAmountFromDebtCovered (getTokenAmountFromUsd collateral debtToCover))
          (bonusCollateral (div (mul tokenAmountFromDebtCovered LIQUIDATION_BONUS) LIQUIDATION_PRECISION)))
      (redeemCollateral collateral (add tokenAmountFromDebtCovered bonusCollateral) user (tx-sender))
      (burnSUSD debtToCover user (tx-sender))
      (let ((endingUserHealthFactor (healthFactor user)))
        (if (<= endingUserHealthFactor startingUserHealthFactor) (revert SUSDEngine__HealthFactorNotImproved) (ok)))
      (if (< (healthFactor (tx-sender)) MIN_HEALTH_FACTOR) (revert SUSDEngine__BreaksHealthFactor (healthFactor (tx-sender))) (ok)))))

(define-public (mintSUSD (amount uint))
  (assert (moreThanZero amount))
  (set (s_SUSDMinted (tx-sender)) (+ (s_SUSDMinted (tx-sender)) amount))
  (if (< (healthFactor (tx-sender)) MIN_HEALTH_FACTOR) (revert SUSDEngine__BreaksHealthFactor (healthFactor (tx-sender))) (ok))
  (let ((minted (contract-call i_susd "mint" (list (tx-sender) amount))))
    (if (not minted) (revert SUSDEngine__MintFailed) (ok))))



(define-public (depositCollateral (tokenCollateralAddress address) (amountCollateral uint))
  (assert (moreThanZero amountCollateral))
  (assert (isAllowedToken tokenCollateralAddress))
  (set (s_collateralDeposited (tx-sender) tokenCollateralAddress) (+ (s_collateralDeposited (tx-sender) tokenCollateralAddress) amountCollateral))
  (emit CollateralDeposited (tx-sender) tokenCollateralAddress amountCollateral)
  (let ((success (contract-call tokenCollateralAddress "transfer-from" (list (tx-sender) (contract-address) amountCollateral))))
    (if (not success) (revert SUSDEngine__TransferFailed) (ok))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Private Functions                        ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define-private (redeemCollateral (tokenCollateralAddress address) (amountCollateral uint) (from address) (to address))
  (set (s_collateralDeposited from tokenCollateralAddress) (- (s_collateralDeposited from tokenCollateralAddress) amountCollateral))
  (emit CollateralRedeemed from to tokenCollateralAddress amountCollateral)
  (let ((success (contract-call tokenCollateralAddress "transfer" (list to amountCollateral))))
    (if (not success) (revert SUSDEngine__TransferFailed) (ok))))

(define-private (burnSUSD (amount uint) (onBehalfOf address) (susdFrom address))
  (set (s_SUSDMinted onBehalfOf) (- (s_SUSDMinted onBehalfOf) amount))
  (let ((success (contract-call i_susd "transfer-from" (list susdFrom (contract-address) amount))))
    (if (not success) (revert SUSDEngine__TransferFailed) (ok)))
  (contract-call i_susd "burn" (list amount)))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Private, Internal Funcs                  ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define-private (S_getAccountInformation (address user))
  (let (s_totalSUSDMinted (map-get s_SUSDMinted user)))
  (let (collateralValueInUSD (getAccountCollateralValue user)))
  (ok s_totalSUSDMinted collateralValueInUSD))