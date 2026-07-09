# Release Notes — v1.0.0

**Title:** x402-Ethereum: HTTP 402 Payment-Gated Routing on Ethereum
**Version:** 1.0.0
**Date:** 2026-07-09
**Author:** Richard Patterson (@De-ASI-INTERFACE)

---

## Summary

First stable, versioned release of the x402-Ethereum Extension. Establishes a canonical, machine-verifiable, and institutionally attributed record of the x402-Ethereum protocol extension as originated and authored by Richard Patterson.

---

## Contents

| File | Description |
|---|---|
| `docs/x402-ethereum-specification.md` | Full EIP-712 payment schema and routing spec |
| `docs/prior-art-and-attribution.md` | Prior art record and implementation history |
| `docs/x402-ethereum-council-charter.md` | Stewardship council charter |
| `docs/reference-implementations.md` | Canonical implementation links |
| `docs/formal-models/PaymentVerification.lean` | Lean 4 ERC-20 payment verification proofs |
| `CITATION.cff` | Academic citation metadata |
| `lakefile.lean` + `lean-toolchain` | Lean 4 v4.14.0 + Mathlib4 build config |
| `.github/workflows/lean-build.yml` | CI: automated Lean 4 build and theorem verification |

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

---

## Attribution

All artifacts in this release were originated and authored by Richard Patterson (@De-ASI-INTERFACE).
