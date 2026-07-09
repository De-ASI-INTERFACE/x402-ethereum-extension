-- ============================================================
-- x402-Ethereum: Basic Re-export Shim
-- Author: Richard Patterson (@De-ASI-INTERFACE)
-- Date: 2026-07-09
-- Chain: Ethereum / ERC-20 / EIP-712 / Uniswap v4
--
-- This module re-exports X402Ethereum.PaymentVerification as the
-- single authoritative source of PaymentAuth, FacilitatorState,
-- and verify. Chain-prefixed theorem aliases are provided here
-- for ergonomic use in downstream consumers.
-- ============================================================
import X402Ethereum.PaymentVerification

namespace X402Ethereum

/-- Alias: replay prevention under the Ethereum chain prefix. -/
theorem ethereum_replay_prevented
    (a : PaymentAuth) (s : FacilitatorState) (h : verify a s) :
    a.nonce ∉ s.used_nonces :=
  replay_prevented a s h

/-- Alias: expiry enforcement under the Ethereum chain prefix. -/
theorem ethereum_not_expired
    (a : PaymentAuth) (s : FacilitatorState) (h : verify a s) :
    s.block_time ≤ a.expires_at :=
  within_expiry a s h

end X402Ethereum
