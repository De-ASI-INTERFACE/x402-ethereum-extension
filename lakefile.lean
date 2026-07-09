import Lake
open Lake DSL

package «x402-ethereum» where
  name := "x402-ethereum"

require mathlib from git
  "https://github.com/leanprover-community/mathlib4" @ "v4.14.0"

lean_lib «X402Ethereum» where
  roots := #[`X402Ethereum]
