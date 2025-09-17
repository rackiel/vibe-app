# VIBE App - APK Build Instructions

This document explains how to build APK files for the VIBE (Visual Interactive Experience) app using GitHub Actions.

## 🚀 Quick Start

### Method 1: Automatic Build (Recommended)

1. **Push your code to GitHub**:
   ```bash
   git add .
   git commit -m "Add GitHub Actions workflow"
   git push origin main
   ```

2. **Check GitHub Actions**:
   - Go to your GitHub repository
   - Click on "Actions" tab
   - You'll see the build workflow running
   - Wait for it to complete (usually 5-10 minutes)

3. **Download APK**:
   - Once complete, go to the "Artifacts" section
   - Download the APK file(s) you need:
     - `debug-apk`: For testing
     - `release-apk`: For production

### Method 2: Manual Trigger

1. Go to your GitHub repository
2. Click "Actions" tab
3. Select "Build Flutter APK" workflow
4. Click "Run workflow"
5. Choose build type and click "Run workflow"

## 📱 APK Types

- **Debug APK**: For development and testing
- **Release APK**: For production use (optimized)
- **Profile APK**: For performance testing

## 🔧 Workflow Features

### Basic Workflow (`build.yml`)
- Builds both debug and release APKs
- Runs tests automatically
- Uploads APKs as artifacts
- Creates GitHub releases for main branch

### Advanced Workflow (`build-advanced.yml`)
- Builds all three APK types (debug, release, profile)
- Code analysis and test coverage
- Matrix strategy for parallel builds
- Enhanced release notes

## 📋 Prerequisites

- GitHub repository (public or private)
- Flutter code pushed to repository
- No local Android SDK required!

## 🛠️ Customization

### Modify Build Settings
Edit `.github/workflows/build.yml` to:
- Change Flutter version
- Add signing keys
- Modify build commands
- Add additional platforms

### Add Signing (Optional)
To sign APKs for Play Store:

1. Add secrets to GitHub repository:
   - `KEYSTORE_PASSWORD`
   - `KEY_ALIAS`
   - `KEY_PASSWORD`
   - `KEYSTORE_BASE64` (base64 encoded keystore file)

2. Uncomment signing section in workflow

## 📊 Monitoring

- Check build status in GitHub Actions
- View logs for debugging
- Download artifacts when ready
- Monitor release notes

## 🆘 Troubleshooting

### Common Issues:
1. **Build fails**: Check Flutter version compatibility
2. **Tests fail**: Fix failing tests before building
3. **Dependencies**: Ensure all dependencies are in `pubspec.yaml`

### Getting Help:
- Check GitHub Actions logs
- Review Flutter documentation
- Check repository issues

## 🎯 Next Steps

1. Push your code to GitHub
2. Wait for first build to complete
3. Download and test your APK
4. Share with users or upload to Play Store

---

**Note**: This method builds APKs in the cloud, so you don't need Android SDK installed locally!
