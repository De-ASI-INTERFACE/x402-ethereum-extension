-- ============================================================
-- x402-Ethereum: Uniswap v4 Routing Invariants
-- Author: Richard Patterson (@De-ASI-INTERFACE)
-- Date: 2026-07-09
-- ============================================================
import Mathlib.Data.Nat.Basic
import X402Ethereum.PaymentVerification

namespace X402Ethereum.Uniswap

structure PoolKey where
  currency0 : Nat; currency1 : Nat
  fee       : Nat; tick_spacing : Nat
  deriving Repr

structure SwapRoute where
  pool_key       : PoolKey
  amount_in      : Nat
  min_amount_out : Nat
  sqrt_price_limit : Nat
  deriving Repr

structure GatedSwap where
  auth  : PaymentAuth
  route : SwapRoute
  deriving Repr

def route_authorized (gs : GatedSwap) (s : FacilitatorState) : Prop :=
  verify gs.auth s

def route_sane (gs : GatedSwap) : Prop :=
  0 < gs.route.min_amount_out ∧
  gs.auth.amount = gs.route.amount_in

def gated_swap_valid (gs : GatedSwap) (s : FacilitatorState) : Prop :=
  route_authorized gs s ∧ route_sane gs

theorem gated_swap_requires_payment
    (gs : GatedSwap) (s : FacilitatorState)
    (h : gated_swap_valid gs s) :
    gs.auth.nonce ∉ s.used_nonces :=
  replay_prevented gs.auth s h.1

end X402Ethereum.Uniswap
