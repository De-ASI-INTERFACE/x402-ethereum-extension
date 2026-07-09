-- x402-Ethereum: Formal Verification Model
-- Author: Richard Patterson (@De-ASI-INTERFACE)
-- Date: 2026-07-09 | Lean 4 / Mathlib4

import Mathlib.Data.Finset.Basic

namespace X402Ethereum

structure PaymentProof where
  payer        : UInt64
  payee        : UInt64
  amount       : UInt64
  nonce        : UInt64
  deadline     : UInt64
  resourceHash : UInt64
  deriving Repr

def UsedNonces := Finset UInt64

def isValid (proof : PaymentProof) (used : UsedNonces) (now : UInt64) : Bool :=
  !used.contains proof.nonce && proof.deadline > now

-- Theorem: once nonce is used, payment cannot be replayed
theorem ethereum_payment_no_double_spend
    (proof : PaymentProof) (used : UsedNonces) (now : UInt64)
    (h : used.contains proof.nonce) :
    isValid proof used now = false := by
  simp [isValid, h]

end X402Ethereum
