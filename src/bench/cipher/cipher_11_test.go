package cipher_test

import (
	"crypto/aes"
	"crypto/cipher"
	"testing"
)

func BenchmarkAESCFBEncrypt(b *testing.B) {
	buf := make([]byte, 1023)
	b.SetBytes(int64(len(buf)))

	var key [16]byte
	var iv [16]byte
	aes, _ := aes.NewCipher(key[:])
	ctr := cipher.NewCFBEncrypter(aes, iv[:])

	b.ResetTimer()
	for i := 0; i < b.N; i++ {
		ctr.XORKeyStream(buf, buf)
	}
}

func BenchmarkAESCFBDecrypt(b *testing.B) {
	buf := make([]byte, 1023)
	b.SetBytes(int64(len(buf)))

	var key [16]byte
	var iv [16]byte
	aes, _ := aes.NewCipher(key[:])
	ctr := cipher.NewCFBDecrypter(aes, iv[:])

	b.ResetTimer()
	for i := 0; i < b.N; i++ {
		ctr.XORKeyStream(buf, buf)
	}
}

func BenchmarkAESOFB(b *testing.B) {
	buf := make([]byte, 1023)
	b.SetBytes(int64(len(buf)))

	var key [16]byte
	var iv [16]byte
	aes, _ := aes.NewCipher(key[:])
	ctr := cipher.NewOFB(aes, iv[:])

	b.ResetTimer()
	for i := 0; i < b.N; i++ {
		ctr.XORKeyStream(buf, buf)
	}
}

func BenchmarkAESCTR(b *testing.B) {
	buf := make([]byte, 1023)
	b.SetBytes(int64(len(buf)))

	var key [16]byte
	var iv [16]byte
	aes, _ := aes.NewCipher(key[:])
	ctr := cipher.NewCTR(aes, iv[:])

	b.ResetTimer()
	for i := 0; i < b.N; i++ {
		ctr.XORKeyStream(buf, buf)
	}
}

func BenchmarkAESCBCEncrypt(b *testing.B) {
	buf := make([]byte, 1024)
	b.SetBytes(int64(len(buf)))

	var key [16]byte
	var iv [16]byte
	aes, _ := aes.NewCipher(key[:])
	cbc := cipher.NewCBCEncrypter(aes, iv[:])
	for i := 0; i < b.N; i++ {
		cbc.CryptBlocks(buf, buf)
	}
}

func BenchmarkAESCBCDecrypt(b *testing.B) {
	buf := make([]byte, 1024)
	b.SetBytes(int64(len(buf)))

	var key [16]byte
	var iv [16]byte
	aes, _ := aes.NewCipher(key[:])
	cbc := cipher.NewCBCDecrypter(aes, iv[:])
	for i := 0; i < b.N; i++ {
		cbc.CryptBlocks(buf, buf)
	}
}
