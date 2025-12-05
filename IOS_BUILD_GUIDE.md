# iOS Build Guide for Windows Users

## Important Note
**APK files are for Android devices only. iOS devices require IPA files.**

You **cannot** build iOS apps directly on Windows. iOS apps can only be built on macOS with Xcode.

## Solutions to Build iOS App from Windows

### Option 1: Cloud Mac Services (Recommended)
Use a cloud-based Mac service to access macOS remotely:

#### MacStadium
- Website: https://www.macstadium.com/
- Pricing: Pay-per-use or monthly plans
- Access: Remote desktop to macOS
- Steps:
  1. Sign up for MacStadium
  2. Get remote access to macOS
  3. Install Xcode and Flutter
  4. Build your iOS app

#### MacinCloud
- Website: https://www.macincloud.com/
- Pricing: Starting from $20/month
- Access: Remote desktop or SSH
- Steps:
  1. Subscribe to MacinCloud
  2. Connect via Remote Desktop
  3. Install Xcode and Flutter
  4. Build your iOS app

#### AWS EC2 Mac Instances
- Website: https://aws.amazon.com/ec2/instance-types/mac/
- Pricing: Pay-per-hour
- Access: SSH or Remote Desktop
- Steps:
  1. Launch EC2 Mac instance
  2. Connect via SSH
  3. Install Xcode and Flutter
  4. Build your iOS app

### Option 2: CI/CD Services with macOS Runners

#### Codemagic
- Website: https://codemagic.io/
- Free tier: 500 build minutes/month
- Steps:
  1. Connect your Git repository
  2. Configure iOS build settings
  3. Build automatically on push
  4. Download IPA file

#### GitHub Actions
- Website: https://github.com/features/actions
- Free tier: 2,000 minutes/month for private repos
- Steps:
  1. Create `.github/workflows/ios.yml`
  2. Configure macOS runner
  3. Build on push/PR
  4. Download IPA artifact

#### AppCircle
- Website: https://appcircle.io/
- Free tier available
- Steps:
  1. Connect repository
  2. Configure iOS build
  3. Build and download IPA

### Option 3: Physical Mac Access
- Borrow a Mac from friend/colleague
- Use a Mac at work/school
- Purchase a Mac (Mac Mini is most affordable)

### Option 4: Build Commands (When You Have macOS Access)

Once you have access to macOS, use these commands:

```bash
# Navigate to project
cd JSR_frontend/jsr_app

# Get dependencies
flutter pub get

# Build for iOS device (creates .app)
flutter build ios --release

# Build IPA file (for distribution)
flutter build ipa --release

# The IPA will be at:
# build/ios/ipa/jsr_app.ipa
```

### Option 5: Using Xcode (When You Have macOS Access)

1. Open project in Xcode:
   ```bash
   open ios/Runner.xcworkspace
   ```

2. Configure signing:
   - Select Runner project
   - Go to "Signing & Capabilities"
   - Select your Apple Developer Team
   - Xcode will manage certificates automatically

3. Connect iOS device:
   - Connect iPhone/iPad via USB
   - Trust the computer on device
   - Select device in Xcode

4. Build and run:
   - Click Run (▶️) button
   - Or press Cmd+R

## Quick Setup Script for macOS (When Available)

Save this as `setup_ios_build.sh`:

```bash
#!/bin/bash
# iOS Build Setup Script

echo "Setting up iOS build environment..."

# Check if Xcode is installed
if ! command -v xcodebuild &> /dev/null; then
    echo "Xcode not found. Please install Xcode from App Store."
    exit 1
fi

# Accept Xcode license
sudo xcodebuild -license accept

# Install CocoaPods (if not installed)
if ! command -v pod &> /dev/null; then
    echo "Installing CocoaPods..."
    sudo gem install cocoapods
fi

# Navigate to project
cd JSR_frontend/jsr_app

# Get Flutter dependencies
flutter pub get

# Install iOS dependencies
cd ios
pod install
cd ..

echo "Setup complete! You can now build iOS app."
echo "Run: flutter build ios --release"
```

## Current iOS Configuration

Your project is already configured for iOS:
- ✅ Bundle ID: `com.example.jsrApp`
- ✅ Deployment Target: iOS 13.0+
- ✅ Supports iPhone and iPad
- ✅ HTTPS configured
- ✅ WhatsApp URL schemes configured
- ✅ File sharing enabled

## Recommended Approach

**For Windows users, I recommend Codemagic or GitHub Actions** because:
1. Free tier available
2. No need to manage Mac infrastructure
3. Automatic builds on code changes
4. Easy to set up
5. Can download IPA directly

## Next Steps

1. Choose a solution from above
2. Set up your chosen method
3. Build your iOS app
4. Test on physical iOS device
5. Distribute via App Store or TestFlight

