# WikiClimb Flutter Frontend

![example workflow](https://github.com/wikiclimb/ftr-frontend/actions/workflows/tests.yml/badge.svg)
[![codecov](https://codecov.io/gh/wikiclimb/ftr-frontend/branch/main/graph/badge.svg?token=ITEIOP66UX)](https://codecov.io/gh/wikiclimb/ftr-frontend)

---

![wikiclimb-logo](graphics/wikiclimb-logo-150.png)

WikiClimb's multiplatform frontend.

## About WikiClimb

To learn more about WikiClimb and its mission, visit the [organization's profile page](https://github.com/wikiclimb).

## About this repository

This project holds the code to WikiClimb's multiplatform frontend.

The project consists of a Flutter application that is intended to run in multiple platforms, at the current time, only Android and iOS are supported in portrait view but there are plans to gradually expand support to other formats.

Contributions are welcome.

## Running the frontend locally

Preconditions

- Git needs to be installed
- Flutter needs to be installed and in the path

First clone the repository (Git needs to be installed)

```
git clone https://github.com/wikiclimb/ftr-frontend.git`
```

Install the pub dependencies

```
flutter pub get
```

Run build runner to generate mocks and built value classes

```
flutter pub run build_runner build
```

Run the tests

```
flutter test
```

The result should show no errors.

There are some parameters that can be passed to the test command, besides also checking formatting and analyzing the code. It is convenient to frequently perform all these actions, to which end there is a script that can be run to do all these actions typing `./ut` while at the root of the project.

The script can be checked [here](./ut), and it does the following:

- Clear the terminal to start with a clean slate
- Call flutter format, and report errors if any file needs formatting
- Call flutter analyze and report errors and warnings
- Call flutter test with random order and coverage report generation
- Remove generated files ‘\*.g.dart’ from the coverage report

The script takes longer to run than just calling flutter test but more checks are performed.

## Fetching data from the backend

By default, when you run the project, it will direct all the requests to https://api.wikiclimb.org, and it will fetch static resources from the same server, you can customize that using command line parameters.

For example, if you want to use the [`yii2-backend`](https://github.com/wikiclimb/yii2-backend) with the default configuration found at [`docker-compose.yml`](https://github.com/wikiclimb/yii2-backend/blob/main/docker-compose.yml), you could use the following commands to start the Flutter application.

```
flutter run –dart-define=API_URL=https://10.0.2.2:22080 (android)
flutter run –dart-define=API_URL=https://127.0.0.1:22080 (others)
```

## Testing

The project has been developed using a TDD approach. Some caveats found.

Mockito matchers do not play well with null safety. When having problems mocking a class, check https://github.com/dart-lang/mockito/blob/master/NULL_SAFETY_README.md

Most of the test code has been migrated to use [Mocktail](https://pub.dev/packages/mocktail). It is recommended to use this package instead of [Mockito](https://pub.dev/packages/mockito), the package integrates better with BLoC and its matchers work without code generation. Check the [package documentation](https://pub.dev/packages/mocktail) for more details.

### Code coverage

Some code is intentionally excluded from code coverage reports. For example abstract classes without any logic. Use:

```dart
// Ignore lines from coverage
// coverage:ignore-line to ignore one line.
// coverage:ignore-start and // coverage:ignore-end to ignore range of lines inclusive.
// coverage:ignore-file to ignore the whole file.
```

To test using the Android emulator and connect to the development server in localhost, we can't use `localhost` or `127.0.0.1` as it is usual, instead use `10.0.2.2` as the host name.

If using the standard development server launched through docker, we can connect to the API on:

```
https://10.0.2.2:22080
```
