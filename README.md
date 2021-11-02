# WikiClimb Flutter Frontend

![example workflow](https://github.com/wikiclimb/ftr-frontend/actions/workflows/tests.yml/badge.svg)
[![codecov](https://codecov.io/gh/wikiclimb/ftr-frontend/branch/main/graph/badge.svg?token=ITEIOP66UX)](https://codecov.io/gh/wikiclimb/ftr-frontend)

---

![wikiclimb-logo](graphics/wikiclimb-logo.png)

WikiClimb's multiplatform frontend.

## Testing

The project has been developed using a TDD approach. Some caveats found.

Mockito matchers do not play well with null safety. When having problems mocking a class, check https://github.com/dart-lang/mockito/blob/master/NULL_SAFETY_README.md

Some code is intentionally excluded from code coverage reports. For example abstract classes without any logic. Use:

```dart
// Ignore lines from coverage
// coverage:ignore-line to ignore one line.
// coverage:ignore-start and // coverage:ignore-end to ignore range of lines inclusive.
// coverage:ignore-file to ignore the whole file.
```
