-- ============================================================
-- x402-Ethereum: Payment Verification Formal Proofs
-- Author: Richard Patterson (@De-ASI-INTERFACE)
-- Date: 2026-07-09
-- Chain: Ethereum / ERC-20 / EIP-712 / Uniswap v4
-- ============================================================
import Mathlib.Data.Finset.Basic
import Mathlib.Data.Nat.Basic
import Mathlib.Logic.Basic

namespace X402Ethereum

structure PaymentAuth where
  nonce      : Nat    -- EIP-712 typed nonce
  amount     : Nat    -- ERC-20 token amount (wei units)
  expires_at : Nat    -- block.timestamp deadline
  token      : Nat    -- ERC-20 contract address
  deriving Repr, DecidableEq

structure FacilitatorState where
  used_nonces  : Finset Nat
  block_time   : Nat    -- block.timestamp
  deriving Repr

def not_expired (a : PaymentAuth) (s : FacilitatorState) : Prop :=
  s.block_time ≤ a.expires_at

def nonce_fresh (a : PaymentAuth) (s : FacilitatorState) : Prop :=
  a.nonce ∉ s.used_nonces

def amount_positive (a : PaymentAuth) : Prop :=
  0 < a.amount

def verify (a : PaymentAuth) (s : FacilitatorState) : Prop :=
  not_expired a s ∧ nonce_fresh a s ∧ amount_positive a

theorem replay_prevented
    (a : PaymentAuth) (s : FacilitatorState) (h : verify a s) :
    a.nonce ∉ s.used_nonces := h.2.1

theorem within_expiry
    (a : PaymentAuth) (s : FacilitatorState) (h : verify a s) :
    s.block_time ≤ a.expires_at := h.1

theorem positive_amount
    (a : PaymentAuth) (s : FacilitatorState) (h : verify a s) :
    0 < a.amount := h.2.2

def settle (a : PaymentAuth) (s : FacilitatorState) : FacilitatorState :=
  { s with used_nonces := s.used_nonces ∪ {a.nonce} }

theorem settled_nonce_used
    (a : PaymentAuth) (s : FacilitatorState) (h : verify a s) :
    a.nonce ∈ (settle a s).used_nonces := by
  simp [settle, Finset.mem_union, Finset.mem_singleton]

theorem post_settlement_replay_blocked
    (a : PaymentAuth) (s : FacilitatorState) (h : verify a s) :
    a.nonce ∈ (settle a s).used_nonces ∧
    ¬a.nonce ∉ (settle a s).used_nonces := by
  constructor
  · exact settled_nonce_used a s h
  · simp [settle, Finset.mem_union, Finset.mem_singleton]

end X402Ethereum
