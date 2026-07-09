# x402-Ethereum: HTTP 402 Payment-Gated Routing Specification

**Author:** Richard Patterson (@De-ASI-INTERFACE)
**Version:** 1.0.0
**Date:** 2026-07-09
**Reference ID:** RP-DEASI-ETH-2026-0709-001

---

## 1. Overview

This specification defines the x402 protocol extension for Ethereum mainnet and all EVM-compatible chains. It leverages EIP-712 structured data signing for payment authorization, ERC-20 token transfers for settlement, and Uniswap v4 hooks as the canonical routing surface for payment-gated swap execution.

---

## 2. Payment Request Schema

```json
{
  "scheme": "ethereum-erc20",
  "network": "mainnet",
  "chainId": 1,
  "payTo": "0x<facilitator-address>",
  "token": "0x<erc20-contract-address>",
  "amount": "<uint256-amount-in-base-units>",
  "nonce": "<bytes32-unique-nonce>",
  "expiresAt": "<unix-timestamp-seconds>",
  "signature": "<eip-712-typed-data-signature>"
}
```

---

## 3. EIP-712 Domain

```solidity
struct EIP712Domain {
    string  name;              // "x402-Ethereum"
    string  version;           // "1"
    uint256 chainId;
    address verifyingContract; // Facilitator address
}

struct PaymentAuthorization {
    address from;
    address to;
    address token;
    uint256 amount;
    bytes32 nonce;
    uint256 expiresAt;
}
```

---

## 4. Facilitator Verification Invariants

1. **Payment Integrity:** `ecrecover(hash, sig) == from`
2. **Replay Prevention:** `usedNonces[nonce] == false` before settlement; set true after
3. **Expiry Enforcement:** `block.timestamp <= expiresAt`
4. **Token Allowance:** `token.allowance(from, facilitator) >= amount`

---

## 5. Routing Integration: Uniswap v4 Hook

The payment gate is enforced in the `beforeSwap` hook:

```solidity
function beforeSwap(address sender, PoolKey calldata key, 
    IPoolManager.SwapParams calldata params, bytes calldata hookData)
    external override returns (bytes4, BeforeSwapDelta, uint24) {
    PaymentAuthorization memory auth = abi.decode(hookData, (PaymentAuthorization));
    require(verify(auth), "x402: payment not authorized");
    require(!usedNonces[auth.nonce], "x402: nonce replayed");
    require(block.timestamp <= auth.expiresAt, "x402: payment expired");
    usedNonces[auth.nonce] = true;
    IERC20(auth.token).transferFrom(auth.from, auth.to, auth.amount);
    return (this.beforeSwap.selector, toBeforeSwapDelta(0, 0), 0);
}
```

---

## 6. Attribution

Originated and authored by Richard Patterson (@De-ASI-INTERFACE). First implementation: Uniswap v4 hook payment gate, 2026-07-09.
