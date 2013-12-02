// +build !go1.1,!go1.0

package cipher_test

import (
	"crypto/aes"
	"crypto/cipher"
	"testing"
)

func BenchmarkAESGCMSeal(b *testing.B) {
	buf := make([]byte, 1024)
	b.SetBytes(int64(len(buf)))

	var key [16]byte
	var nonce [12]byte
	aes, _ := aes.NewCipher(key[:])
	aesgcm, _ := cipher.NewGCM(aes)
	var out []byte

	b.ResetTimer()
	for i := 0; i < b.N; i++ {
		out = aesgcm.Seal(out[:0], nonce[:], buf, nonce[:])
	}
}

func BenchmarkAESGCMOpen(b *testing.B) {
	buf := make([]byte, 1024)
	b.SetBytes(int64(len(buf)))

	var key [16]byte
	var nonce [12]byte
	aes, _ := aes.NewCipher(key[:])
	aesgcm, _ := cipher.NewGCM(aes)
	var out []byte
	out = aesgcm.Seal(out[:0], nonce[:], buf, nonce[:])

	b.ResetTimer()
	for i := 0; i < b.N; i++ {
		_, err := aesgcm.Open(buf, nonce[:], out, nonce[:])
		if err != nil {
			b.Errorf("Open: %v", err)
		}
	}
}
