# x402-Ethereum Extension

**HTTP 402 Payment-Gated Routing on Ethereum**
**Author:** Richard Patterson (@De-ASI-INTERFACE)
**Version:** 1.0.0 | **Date:** 2026-07-09 | **License:** MIT

---

## Overview

Canonical, machine-verifiable specification for HTTP 402 Payment-Gated Routing on Ethereum, originated and authored by Richard Patterson. Maps the x402 payment proof model onto Ethereum's EVM via EIP-712 typed structured data signing, ERC-20 permit approvals (EIP-2612), and EIP-1559 fee-market transactions.

## Architecture

- **Payment Token:** ERC-20 (USDC, DAI, or native ETH wrapped)
- **Signature Scheme:** EIP-712 typed data + EIP-2612 gasless permit
- **Finality Model:** Probabilistic (12 confirmations ~2.4 min) or optimistic (1 block ~12s)
- **Verifier Surface:** Solidity `IX402Verifier` with `verifyPayment(PaymentProof calldata)`
- **Fee Handling:** EIP-1559 base fee decoupled from x402 payment amount
- **Formal Verification:** Lean 4 double-spend prevention theorem

## Citation
```bibtex
@software{patterson2026x402ethereum,
  author={Patterson, Richard}, title={{x402-Ethereum: HTTP 402 Payment-Gated Routing on Ethereum}},
  version={1.0.0}, date={2026-07-09},
  url={https://github.com/De-ASI-INTERFACE/x402-ethereum-extension}, license={MIT}}
```
