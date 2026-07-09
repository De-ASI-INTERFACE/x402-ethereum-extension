-- x402-Ethereum Payment Verification | Author: Richard Patterson
import X402Ethereum.Basic

namespace X402Ethereum.Verification

def settle (a : PaymentAuth) (s : FacilitatorState) (h : verify a s) : FacilitatorState :=
  { s with used_nonces := s.used_nonces ∪ {a.nonce} }

theorem settled_nonce_recorded (a : PaymentAuth) (s : FacilitatorState) (h : verify a s)
    : a.nonce ∈ (settle a s h).used_nonces := by
  simp [settle, Finset.mem_union, Finset.mem_singleton]

end X402Ethereum.Verification
