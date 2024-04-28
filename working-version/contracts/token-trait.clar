
;; ;; title: nft-trait
;; ;; version:
;; ;; summary:
;; ;; description:

;; ;; traits
;; ;;
;; (define-trait sip-010-trait
;;   (
;;     ;; Last token ID, limited to uint range
;;     (get-last-token-id () (response uint uint))

;;     ;; URI for metadata associated with the token
;;     (get-token-uri (uint) (response (optional (string-ascii 256)) uint))

;;      ;; Owner of a given token identifier
;;     (get-owner (uint) (response (optional principal) uint))

;;     ;; Transfer from the sender to a new principal
;;     (transfer (uint principal principal) (response bool uint))
;;   )
;; )



;; ;; token definitions
;; ;;

;; ;; constants
;; ;;

;; ;; data vars
;; ;;

;; ;; data maps
;; ;;

;; ;; public functions
;; ;;

;; ;; read only functions
;; ;;

;; ;; private functions
;; ;;

