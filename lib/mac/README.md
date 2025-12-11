# Mac Utils

This module provides macOS-specific utilities for the friday_gemini_ai gem.

## Methods

### `MacUtils.mac?`

Returns `true` if the current platform is macOS (Darwin), `false` otherwise.

### `MacUtils.version`

Returns the macOS version string (e.g., "14.1") if running on macOS, `nil` otherwise.

## Usage

```ruby
require 'mac/mac_utils'

if MacUtils.mac?
  puts "Running on macOS version #{MacUtils.version}"
end
```