# Code Style

## Language Idioms

Always be idiomatic to the language in use. Naming conventions, file structure, and patterns should be immediately recognizable to an expert in that language. In Python: snake_case for variables/functions, PascalCase for classes. Blend in — don't impose conventions from other languages.

## Naming

- Types and classes are **nouns**. Functions and methods are **verbs**. A noun function is a smell for overly imperative code.
- No overly short names. Exception: `i`, `j` for loop indices is fine and expected.
- No overly specific names that just restate the calculation: `sum = x + y`, not `sum_of_x_and_y = x + y`. If `sum` is clear, use `sum`.
- No Systems Hungarian Notation. We have types. If something is an index, name it `index`. Apps Hungarian is acceptable where type alone is insufficient.
- When reusing a well-known concept from a paradigm, use its canonical name: `fold` not `reduce`, `map` not `transform` or `iterate`, `apply`/`fmap`. Don't rename established vocabulary.

## Design Backwards from Invocation

Design APIs starting from how they will be called. If calls will be chained, ensure the chain reads like a sentence: `items.filter(is_valid).map(transform).fold(initial, combine)`. The invocation should tell a story.

## Typing

Use strong types everywhere. In Python, use MyPy annotations on all functions and public members. Type annotations are free unit tests — use them. Do not use Systems Hungarian as a substitute for types.

## Functional Principles

Prefer immutability. Prefer pure functions. Minimize side effects even in OO code. Smaller, single-purpose functions are easier to reason about. Remember: `obj = func(obj)` and `obj.func()` are equivalent — mutable OO is a choice, not a requirement.

## Object-Oriented Design

Think in **message passing**, not commands. Design objects around: "what can be told to this object, and how might it respond?" When you have 12–15 functions that all operate exclusively on one type, you likely have a secret class.

## Error Handling

Prefer monadic error handling (Result/Optional types). Exceptions are an acceptable poor-man's Result monad, but neither exceptions nor Optionals should be used as flow control. Hoist Optional out of functions where possible — write `x -> y` and apply it to `Optional[x]`, rather than having the function return `Optional[y]`. Error hard, early, and clearly. Limping along with partial errors creates undefined behavior downstream.

## Abstractions and DRY

DRY is a guideline, not a law. The wrong abstraction is often more costly than duplication. A useful abstraction reveals something real about the domain — it elucidates an inherent truth in the model. An abstraction that just reduces line count is not automatically worth the indirection.

## Comments

Comments explain **why** or **what is being achieved** — never what the code is doing (the code already says that).

Bad: `sum = x + y  # add x and y`
Good: `sum = x + y  # x and y can't be passed separately to the downstream API`

Doc comments go on **every public member**. Do not repeat what the type annotations already say. Do not describe the implementation. Do explain why the function exists, what contract it fulfills, or what is non-obvious about its behavior.
