# Mac Notch Timer

Mac Notch Timer is a small macOS menu-less timer that lives at the top of the screen around the MacBook notch. It starts a five-minute countdown, stays tucked into a thin hover target, and expands to show the remaining time when you hover near the notch.

## Development

To build and run the app from source:

```sh
swift run MacNotchTimer
```

## Install with Homebrew

Tap the Homebrew repository, then install the formula:

```sh
brew tap maujim/mac-notch-timer
brew install mac-notch-timer
```

Start the LaunchAgent with Homebrew services:

```sh
brew services start mac-notch-timer
```

`brew services start` launches Mac Notch Timer immediately and configures it to run again when you log in.

## Manage the service

Stop Mac Notch Timer and disable launch-at-login:

```sh
brew services stop mac-notch-timer
```

Restart it after upgrading or changing the service:

```sh
brew services restart mac-notch-timer
```

Uninstall Mac Notch Timer:

```sh
brew services stop mac-notch-timer
brew uninstall mac-notch-timer
brew untap maujim/mac-notch-timer
```
