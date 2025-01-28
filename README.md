# Lisu Keyboard for iOS

A custom iOS keyboard extension that provides Lisu script input support for iPhone and iPad devices. The keyboard is optimized for both portrait and landscape orientations with special considerations for iPad screens.

## Features

- 📱 Full support for iPhone and iPad devices
- 🔄 Adaptive layout for portrait and landscape orientations
- ⌨️ Custom key layouts for different input modes:
  - Lisu script input
  - Number pad
  - Symbol pad
- 🎯 Optimized key sizes and touch areas
- 🔤 Custom font support for Lisu script
- ⚡ Long-press backspace for continuous deletion
- 🌙 Support for both light and dark modes

## Requirements

- iOS 15.0+
- Xcode 14.0+
- Swift 5.0+

## Installation

1. Clone the repository:
```bash
git clone https://github.com/yourusername/Lisu-Keyboard.git
```

2. Open `Lisu Keyboard.xcodeproj` in Xcode

3. Select your development team in both the main app and keyboard extension targets

4. Build and run the project

## Usage

1. Install the app on your iOS device
2. Go to Settings > General > Keyboard > Keyboards
3. Tap "Add New Keyboard"
4. Select "Lisu Keyboard" under Third-Party Keyboards
5. Enable "Allow Full Access" for full keyboard functionality

## Keyboard Layout

The keyboard includes multiple layouts:
- Default Lisu script layout
- Shifted Lisu layout
- Number pad
- Symbol pad

Key features:
- Optimized key spacing and sizing
- Special handling for iPad screens
- Landscape mode support
- Enhanced touch areas for better typing experience

## Development

### Project Structure

```
Lisu Keyboard/
├── Lisu/
│   ├── Views/
│   │   ├── KeyButton.swift
│   │   ├── KeyboardContentView.swift
│   │   └── KeyPopoverView.swift
│   ├── Helpers/
│   │   ├── DeviceHelper.swift
│   │   ├── FontHelper.swift
│   │   └── LayoutHelper.swift
│   ├── Models/
│   │   ├── OrientationManager.swift
│   │   ├── ViewDelegate.swift
│   │   └── ViewModel.swift
│   └── States/
│       └── KeyboardState.swift
└── LisuKeyboard/
    └── KeyboardViewController.swift
```

### Key Components

- `KeyboardViewController`: Main controller for the keyboard extension
- `KeyboardContentView`: Manages the layout and display of keys
- `KeyButton`: Custom button implementation with support for long-press and popover
- `KeyboardLayoutHelper`: Handles layout calculations and key sizing
- `DeviceHelper`: Provides device-specific information and adjustments

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- Thanks to all contributors who have helped with the development
- Special thanks to the Lisu community for their support and feedback
