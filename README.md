# BijectiveMorphisms.jl [![Build Status](https://github.com/p-phi/BijectiveMorphisms.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/p-phi/BijectiveMorphisms.jl/actions/workflows/CI.yml?query=branch%3Amain)

> Type-safe, no math  
> Lean back, no fat  
> Dispatch, on track  
> Biject, no slack

---

## Motivation

This package provides a lightweight framework for safer composition of reversible transformations at an engineering level. It defines a small `AbstractBijectiveMorphism{A,B}` hierarchy that leverages Julia’s parametric types and multiple dispatch to make domain, codomain, forward map, and inverse map explicit, with composition closed within the abstraction.

Packages such as [Bijections.jl](https://github.com/JuliaCollections/Bijections.jl) and [InverseFunctions.jl](https://github.com/JuliaMath/InverseFunctions.jl) address related concerns — reversible map containers and function inversion protocols, respectively — but do not provide a minimal, typed structure for composable reversible transformations. This package is intended to fill that gap.

## ✨ Features

- 🔁 First-class `BijectiveMorphism` type
- ∘ Composition with static type checking
- ⁻¹ Inversion of simple and composed bijective morphisms
- 📐 Domain/codomain enforcement at call time
- 🧪 Round-trip validation helpers
- 🖥️ Clean REPL display

## 📦 Installation

```julia
using Pkg
Pkg.add("BijectiveMorphisms")
```

## 🚀 Quick start

```julia
using BijectiveMorphisms

f = BijectiveMorphism(x -> x + 1,
              x -> x - 1,
              Int, Int)

f(10)
# 11

inverse(f)(11)
# 10
```

## ∘ Composition

BijectiveMorphisms compose like functions, with full type safety:

```julia
g = BijectiveMorphism(x -> x * 2,
              x -> x ÷ 2,
              Int, Int)

h = g ∘ f

h(10)
# 22

inverse(h)(22)
# 10
```

Composition is only allowed when the intermediate types match.

## 🧪 Round-trip validation

BijectiveMorphisms.jl does **not** try to prove bijectivity at construction time.
Instead, it provides a practical correctness check:

```julia
validate(f, 1:100)
# true
```

Custom equality:

```julia
b = BijectiveMorphism(sqrt, x -> x^2, Float64, Float64)

validate(b, 1:10; eq = ≈)  # true
```

You stay in control of the acceptable numerical or structural error.

## 📐 Design philosophy

BijectiveMorphisms.jl enforces:

- domain and codomain types
- compositional correctness

BijectiveMorphisms.jl deliberately does **not** enforce:

- mathematical bijectivity

This keeps the abstraction:

- flexible for numerical work
- usable with lossy but reversible transforms
- lightweight and fast

You are responsible for defining meaningful inverses;
BijectiveMorphisms.jl guarantees that they are used consistently.

## 🧠 API overview

### Core

- `BijectiveMorphism(f, g, A, B)`
- `inverse(b)`
- `b(x)`

### Composition

- `compose(b2, b1)`
- `b2 ∘ b1`

### Validation

- `validate(b, xs; eq = isequal)`

### Docstrings

```julia
?BijectiveMorphism
?inverse
?validate
?ComposedBijectiveMorphism
```

## Conceptual inspiration

The conceptual motivation behind BijectiveMorphism.jl is _Bijectivism_, which illustrates the idea that every transformation is reversible.

A more detailed description of this epistemic stance is available on [Zenodo](https://zenodo.org/records/18724502).

## 🤝 Contributing

Issues and PRs are welcome.

## 📄 License

MIT
