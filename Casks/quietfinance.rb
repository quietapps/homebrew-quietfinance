cask "quietfinance" do
  version "2.6.0"
  sha256 "64902685c4c79c64319677f9629cce0265f537b7584f05e147543fd896719896"  # set by scripts/release.sh output

  url "https://github.com/quietapps/QuietFinance/releases/download/v#{version}/QuietFinance-#{version}.zip",
      verified: "github.com/quietapps/QuietFinance/"
  name "Quiet Finance"
  desc "Track your net worth. Offline. No subscriptions. No cloud."
  homepage "https://github.com/quietapps/QuietFinance"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates false
  depends_on macos: ">= :tahoe"

  app "QuietFinance.app"

  postflight do
    system_command "/usr/bin/xattr",
                   args: ["-cr", "#{appdir}/QuietFinance.app"],
                   sudo: false
    system_command "/System/Library/Frameworks/CoreServices.framework/" \
                   "Versions/A/Frameworks/LaunchServices.framework/" \
                   "Versions/A/Support/lsregister",
                   args: ["-f", "#{appdir}/QuietFinance.app"],
                   sudo: false,
                   must_succeed: false
  end

  zap trash: [
    "~/Library/Containers/app.quiet.QuietFinance",
    "~/Library/Preferences/app.quiet.QuietFinance.plist",
    "~/Library/Caches/app.quiet.QuietFinance",
    "~/Library/HTTPStorages/app.quiet.QuietFinance",
    "~/Library/Saved Application State/app.quiet.QuietFinance.savedState",
  ]

  caveats <<~EOS
    Quiet Finance is distributed unsigned. The post-install hook strips
    Gatekeeper attributes automatically, but if the app refuses to launch:

      1. Open Finder → /Applications
      2. Right-click QuietFinance.app → Open
      3. Click "Open" in the dialog

    Or run once in Terminal:
      xattr -cr "/Applications/QuietFinance.app"
  EOS
end
