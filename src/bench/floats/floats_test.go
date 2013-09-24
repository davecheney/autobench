package floats

import (
	"math"
	"math/rand"
	"testing"
)

// Copyright 2011 The Go Authors.  All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

// Performs a set of tests on simple mathematical operations with float slices

// Add returns the element-wise sum of all the slices with the
// results stored in the first slice.
// For computational efficiency, it is assumed that all of
// the variadic arguments have the same length. If this is
// in doubt, EqLen can be used.
func Add(dst []float64, slices ...[]float64) []float64 {
	if len(slices) == 0 {
		return nil
	}
	if len(dst) != len(slices[0]) {
		panic("floats: length of destination does not match length of the slices")
	}
	for _, slice := range slices {
		for j, val := range slice {
			dst[j] += val
		}
	}
	return dst
}

// Dot computes the dot product of s1 and s2, i.e.
// sum_{i = 1}^N s1[i]*s2[i].
// A panic will occur if lengths of arguments do not match.
func Dot(s1, s2 []float64) float64 {
	if len(s1) != len(s2) {
		panic("floats: lengths of the slices do not match")
	}
	var sum float64
	for i, val := range s1 {
		sum += val * s2[i]
	}
	return sum
}

// Logsumexp returns the log of the sum of the exponentials of the values in s
func LogSumExp(s []float64) (lse float64) {
	// Want to do this in a numerically stable way which avoids
	// overflow and underflow
	// First, find the maximum value in the slice.
	maxval, _ := Max(s)
	if math.IsInf(maxval, 0) {
		// If it's infinity either way, the logsumexp will be infinity as well
		// returning now avoids NaNs
		return maxval
	}
	// Compute the sumexp part
	for _, val := range s {
		lse += math.Exp(val - maxval)
	}
	// Take the log and add back on the constant taken out
	return math.Log(lse) + maxval
}

// Max returns the maximum value in the slice and the location of
// the maximum value. If the input slice is empty, the code will panic.
func Max(s []float64) (max float64, ind int) {
	max = s[0]
	ind = 0
	for i, val := range s {
		if val > max {
			max = val
			ind = i
		}
	}
	return max, ind
}

// Min returns the minimum value in the slice and the index of
// the minimum value. If the input slice is empty, the code will panic
func Min(s []float64) (min float64, ind int) {
	min = s[0]
	ind = 0
	for i, val := range s {
		if val < min {
			min = val
			ind = i
		}
	}
	return min, ind
}

func RandomSlice(l int) []float64 {
	s := make([]float64, l)
	for i := range s {
		s[i] = rand.Float64()
	}
	return s
}

const (
	EQTOLERANCE = 1E-14
	SMALL       = 10
	MEDIUM      = 1000
	LARGE       = 100000
	HUGE        = 10000000
)

func benchmarkMin(b *testing.B, s []float64) {
	b.ResetTimer()
	for i := 0; i < b.N; i++ {
		_, _ = Min(s)
	}
}

func BenchmarkMinSmall(b *testing.B) {
	s := RandomSlice(SMALL)
	benchmarkMin(b, s)
}

func BenchmarkMinMed(b *testing.B) {
	s := RandomSlice(MEDIUM)
	benchmarkMin(b, s)
}

func BenchmarkMinLarge(b *testing.B) {
	s := RandomSlice(LARGE)
	benchmarkMin(b, s)
}
func BenchmarkMinHuge(b *testing.B) {
	b.StopTimer()
	s := RandomSlice(HUGE)
	benchmarkMin(b, s)
}

func benchmarkAdd(b *testing.B, s ...[]float64) {
	b.ResetTimer()
	for i := 0; i < b.N; i++ {
		Add(s[0], s[1:]...)
	}
}

func BenchmarkAddTwoSmall(b *testing.B) {
	i := SMALL
	s := RandomSlice(i)
	t := RandomSlice(i)
	benchmarkAdd(b, s, t)
}

func BenchmarkAddFourSmall(b *testing.B) {
	i := SMALL
	s := RandomSlice(i)
	t := RandomSlice(i)
	u := RandomSlice(i)
	v := RandomSlice(i)
	benchmarkAdd(b, s, t, u, v)
}

func BenchmarkAddTwoMed(b *testing.B) {
	i := MEDIUM
	s := RandomSlice(i)
	t := RandomSlice(i)
	benchmarkAdd(b, s, t)
}

func BenchmarkAddFourMed(b *testing.B) {
	i := MEDIUM
	s := RandomSlice(i)
	t := RandomSlice(i)
	u := RandomSlice(i)
	v := RandomSlice(i)
	benchmarkAdd(b, s, t, u, v)
}

func BenchmarkAddTwoLarge(b *testing.B) {
	i := LARGE
	s := RandomSlice(i)
	t := RandomSlice(i)
	benchmarkAdd(b, s, t)
}

func BenchmarkAddFourLarge(b *testing.B) {
	i := LARGE
	s := RandomSlice(i)
	t := RandomSlice(i)
	u := RandomSlice(i)
	v := RandomSlice(i)
	benchmarkAdd(b, s, t, u, v)
}

func BenchmarkAddTwoHuge(b *testing.B) {
	i := HUGE
	s := RandomSlice(i)
	t := RandomSlice(i)
	benchmarkAdd(b, s, t)
}

func BenchmarkAddFourHuge(b *testing.B) {
	i := HUGE
	s := RandomSlice(i)
	t := RandomSlice(i)
	u := RandomSlice(i)
	v := RandomSlice(i)
	benchmarkAdd(b, s, t, u, v)
}

func benchmarkLogSumExp(b *testing.B, s []float64) {
	b.ResetTimer()
	for i := 0; i < b.N; i++ {
		_ = LogSumExp(s)
	}
}

func BenchmarkLogSumExpSmall(b *testing.B) {
	s := RandomSlice(SMALL)
	benchmarkLogSumExp(b, s)
}

func BenchmarkLogSumExpMed(b *testing.B) {
	s := RandomSlice(MEDIUM)
	benchmarkLogSumExp(b, s)
}

func BenchmarkLogSumExpLarge(b *testing.B) {
	s := RandomSlice(LARGE)
	benchmarkLogSumExp(b, s)
}
func BenchmarkLogSumExpHuge(b *testing.B) {
	s := RandomSlice(HUGE)
	benchmarkLogSumExp(b, s)
}

func benchmarkDot(b *testing.B, s1 []float64, s2 []float64) {
	b.ResetTimer()
	for i := 0; i < b.N; i++ {
		_ = Dot(s1, s2)
	}
}

func BenchmarkDotSmall(b *testing.B) {
	s1 := RandomSlice(SMALL)
	s2 := RandomSlice(SMALL)
	benchmarkDot(b, s1, s2)
}

func BenchmarkDotMed(b *testing.B) {
	s1 := RandomSlice(MEDIUM)
	s2 := RandomSlice(MEDIUM)
	benchmarkDot(b, s1, s2)
}

func BenchmarkDotLarge(b *testing.B) {
	s1 := RandomSlice(LARGE)
	s2 := RandomSlice(LARGE)
	benchmarkDot(b, s1, s2)
}
func BenchmarkDotHuge(b *testing.B) {
	s1 := RandomSlice(HUGE)
	s2 := RandomSlice(HUGE)
	benchmarkDot(b, s1, s2)
}
