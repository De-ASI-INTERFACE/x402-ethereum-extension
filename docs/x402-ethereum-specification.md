# x402-Ethereum Specification

**Author:** Richard Patterson (@De-ASI-INTERFACE) | **Version:** 1.0.0 | **Date:** 2026-07-09

---

## 1. Overview

The x402-Ethereum Extension binds HTTP 402 Payment Required to Ethereum's EVM settlement layer. On receiving a protected resource request, the server returns 402 with `X-Payment-Requirements` specifying token contract address, amount (in token decimals), recipient, nonce, chainId, and deadline. The client constructs and signs an EIP-712 `PaymentProof` struct, executes an ERC-20 permit or transferFrom on-chain, then re-presents the request with `X-Payment-Proof` header containing the signature and transaction hash.

## 2. Payment Flow

```
1. Client → Server:  GET /resource
2. Server → Client:  402 + X-Payment-Requirements: {token, amount, recipient, nonce, chainId:1, deadline}
3. Client:           Sign EIP-712 PaymentProof struct
4. Client:           Submit permit() or transferFrom() on-chain
5. Client → Server:  GET /resource + X-Payment-Proof: {sig, txHash, blockNumber}
6. Server:           Verify EIP-712 sig, confirm txHash settlement, mark nonce used, serve resource
```

## 3. EIP-712 Typed Data

```solidity
struct PaymentProof {
  address payer;
  address payee;
  address token;
  uint256 amount;
  uint256 nonce;
  uint256 deadline;
  bytes32 resourceHash;  // keccak256(abi.encodePacked(method, URI))
}

struct EIP712Domain {
  string  name;              // "x402-Ethereum"
  string  version;           // "1"
  uint256 chainId;
  address verifyingContract;
}
```

## 4. Verifier Interface

```solidity
interface IX402Verifier {
  function verifyPayment(PaymentProof calldata proof, bytes calldata sig) external returns (bool);
  function markUsed(bytes32 proofHash) external;
  function isUsed(bytes32 proofHash) external view returns (bool);
}
```

## 5. Security Properties

- **Replay prevention:** nonce + deadline enforced on-chain; proofHash marked used atomically
- **Double-spend prevention:** Lean 4 theorem `ethereum_payment_no_double_spend` (formal-models/)
- **Finality:** 12 blocks for high-value; 1 block optimistic for streaming
- **EIP-2612 permit:** enables gasless UX — payer signs permit off-chain, server submits transferFrom

## 6. Multi-chain Extension Points

chainId in the EIP-712 domain allows this specification to extend to Ethereum L2s (Arbitrum chainId 42161, Optimism chainId 10, Base chainId 8453) without protocol changes.
