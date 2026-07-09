-- ============================================================
-- x402-Ethereum: Payment Verification Formal Proofs
-- Author: Richard Patterson (@De-ASI-INTERFACE)
-- Date: 2026-07-09
-- Chain: Ethereum / EIP-712 / Uniswap v4 Hook
-- ============================================================
import Mathlib.Data.Finset.Basic
import Mathlib.Data.Nat.Basic
import Mathlib.Logic.Basic

namespace X402Ethereum

/-- EIP-712 typed payment authorization -/
structure PaymentAuth where
  from_addr   : Nat    -- sender address (simplified as Nat)
  to_addr     : Nat    -- facilitator address
  token       : Nat    -- ERC-20 contract address
  amount      : Nat    -- uint256 amount in token base units
  nonce       : Nat    -- bytes32 unique nonce
  expires_at  : Nat    -- Unix timestamp (seconds)
  chain_id    : Nat    -- EIP-155 chain ID
  deriving Repr, DecidableEq

/-- On-chain Facilitator contract state -/
structure FacilitatorState where
  used_nonces  : Finset Nat
  block_time   : Nat    -- block.timestamp
  chain_id     : Nat
  deriving Repr

-- ── Core Predicates ──────────────────────────────────────────

def not_expired (a : PaymentAuth) (s : FacilitatorState) : Prop :=
  s.block_time ≤ a.expires_at

def nonce_fresh (a : PaymentAuth) (s : FacilitatorState) : Prop :=
  a.nonce ∉ s.used_nonces

def chain_matches (a : PaymentAuth) (s : FacilitatorState) : Prop :=
  a.chain_id = s.chain_id

def amount_positive (a : PaymentAuth) : Prop :=
  0 < a.amount

def verify (a : PaymentAuth) (s : FacilitatorState) : Prop :=
  not_expired a s ∧ nonce_fresh a s ∧ chain_matches a s ∧ amount_positive a

-- ── Theorems ─────────────────────────────────────────────────

theorem replay_prevented (a : PaymentAuth) (s : FacilitatorState)
    (h : verify a s) : a.nonce ∉ s.used_nonces := h.2.1

theorem within_expiry (a : PaymentAuth) (s : FacilitatorState)
    (h : verify a s) : s.block_time ≤ a.expires_at := h.1

theorem correct_chain (a : PaymentAuth) (s : FacilitatorState)
    (h : verify a s) : a.chain_id = s.chain_id := h.2.2.1

theorem positive_amount (a : PaymentAuth) (s : FacilitatorState)
    (h : verify a s) : 0 < a.amount := h.2.2.2

def settle (a : PaymentAuth) (s : FacilitatorState) : FacilitatorState :=
  { s with used_nonces := s.used_nonces ∪ {a.nonce} }

theorem settled_nonce_used (a : PaymentAuth) (s : FacilitatorState)
    (h : verify a s) : a.nonce ∈ (settle a s).used_nonces := by
  simp [settle, Finset.mem_union, Finset.mem_singleton]

theorem nonces_monotone (a : PaymentAuth) (s : FacilitatorState)
    (h : verify a s) : s.used_nonces ⊆ (settle a s).used_nonces := by
  simp [settle]; exact Finset.subset_union_left

end X402Ethereum
