# Dart language specification

[Language specification](https://dart.dev/resources/language/spec)

## Dart 3

* [Latest, in-progress specification][latest draft]
  (produced from a [LaTeX file][])

[latest draft]: https://spec.dart.dev/DartLangSpecDraft.pdf
[LaTeX file]: https://github.com/dart-lang/language/blob/main/specification/dartLangSpec.tex

### Notation

Reserved words and built-in identifiers appear in **bold**.

Grammar productions are given in a common variant of EBNF.
The left hand side of a production ends with `::=`.
On the right hand side, alternation is represented by vertical bars, and sequencing by spacing.
As in PEGs, alternation gives priority to the left.
Optional elements of a production are suffixed by a question mark like so: `anElephant?`.
Appending a star to an element of a production means it may be repeated zero or more times.
Appending a plus sign to a production means it occurs one or more times. Parentheses are used for grouping.
Negation is represented by prefixing an element of a production with a tilde.
Negation is similar to the not combinator of PEGs, but it consumes input if it matches.
In the context of a lexical production it consumes a single character if there is one; otherwise, a single token if there is one.

An example would be:
<pre>
⟨aProduction⟩ ::= ⟨anAlternative⟩
  | ⟨anotherAlternative⟩
  | ⟨oneThing⟩ ⟨after⟩ ⟨another⟩
  | ⟨zeroOrMoreThings⟩*
  | ⟨oneOrMoreThings⟩+
  | ⟨anOptionalThing⟩?
  | (⟨some⟩ ⟨grouped⟩ ⟨things⟩)
  | ~⟨notAThing⟩
  | ‘aTerminal’
  | ⟨A_LEXICAL_THING⟩
  | <b>reserved</b>
</pre>
