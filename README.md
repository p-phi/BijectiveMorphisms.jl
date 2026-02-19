# Bijectivism.jl [![Build Status](https://github.com/p-phi/Bijectivism.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/p-phi/Bijectivism.jl/actions/workflows/CI.yml?query=branch%3Amain)

> Type-safe, no math  
> Lean back, no fat  
> Dispatch, on track  
> Biject, no slack

---

## ✨ Features

- 🔁 First-class `Bijection` type
- ∘ Composition with static type checking
- ⁻¹ Inversion of simple and composed bijections
- 📐 Domain/codomain enforcement at call time
- 🧪 Round-trip validation helpers
- 🖥️ Clean REPL display

---

## 📦 Installation

```julia
using Pkg
Pkg.add("Bijectivism")
```

---

## 🚀 Quick start

```julia
using Bijectivism

f = Bijection(x -> x + 1,
              x -> x - 1,
              Int, Int)

f(10)
# 11

inverse(f)(11)
# 10
```

---

## ∘ Composition

Bijections compose like functions, with full type safety:

```julia
g = Bijection(x -> x * 2,
              x -> x ÷ 2,
              Int, Int)

h = g ∘ f

h(10)
# 22

inverse(h)(22)
# 10
```

Composition is only allowed when the intermediate types match.

---

## 🧪 Round-trip validation

Bijectivism does **not** try to prove bijectivity at construction time.
Instead, it provides a practical correctness check:

```julia
validate(f, 1:100)
# true
```

Custom equality:

```julia
b = Bijection(sqrt, x -> x^2, Float64, Float64)

validate(b, 1:10; eq = ≈)  # true
```

You stay in control of the acceptable numerical or structural error.

---

## 📐 Design philosophy

Bijectivism enforces:

- domain and codomain types
- compositional correctness

Bijectivism deliberately does **not** enforce:

- mathematical bijectivity

This keeps the abstraction:

- flexible for numerical work
- usable with lossy but reversible transforms
- lightweight and fast

You are responsible for defining meaningful inverses;
Bijectivism guarantees that they are used consistently.

---

## 🧠 API overview

### Core

- `Bijection(f, g, A, B)`
- `inverse(b)`
- `b(x)`

### Composition

- `b2 ∘ b1`

### Validation

- `validate(b, xs; eq = isequal)`

---

## 🤝 Contributing

Issues and PRs are welcome.

---

## 📄 License

MIT
