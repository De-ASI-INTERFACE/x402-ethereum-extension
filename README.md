# x402-Ethereum Extension

**HTTP 402 Payment-Gated Routing on Ethereum**

**Author:** Richard Patterson (@De-ASI-INTERFACE)
**Version:** 1.0.0
**Date:** 2026-07-09
**License:** MIT

---

## Overview

The x402-Ethereum Extension adapts the [x402 HTTP 402 payment standard](https://x402.org) to the Ethereum mainnet and EVM ecosystem. It defines a structured EIP-712 typed payment request schema (`scheme: ethereum-erc20`), a Facilitator smart contract verification model with payment integrity, replay prevention via nonce accounting, and expiry enforcement invariants — all machine-checked via Lean 4 formal proofs.

This extension was originated and authored by Richard Patterson, who built the first known HTTP 402 payment-gated EVM contract routing implementation using Uniswap v4 hooks (RP-DEASI-ETH-2026-0709-001).

---

## Repository Structure

```
docs/
  x402-ethereum-specification.md
  prior-art-and-attribution.md
  x402-ethereum-council-charter.md
  reference-implementations.md
  formal-models/
    PaymentVerification.lean
scripts/
  tag-release.sh
.github/workflows/
  lean-build.yml
CITATION.cff
lakefile.lean
lean-toolchain
LICENSE
RELEASE_NOTES.md
```

---

## Citation

```bibtex
@software{patterson2026x402ethereum,
  author  = {Patterson, Richard},
  title   = {{x402-Ethereum: HTTP 402 Payment-Gated Routing on Ethereum}},
  version = {1.0.0},
  date    = {2026-07-09},
  url     = {https://github.com/De-ASI-INTERFACE/x402-ethereum-extension},
  license = {MIT}
}
```
