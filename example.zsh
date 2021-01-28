# Edit Profile
alias editconf="code /Users/$(whoami)/.oh-my-zsh/custom/example.zsh"
alias openconf="cd /Users/$(whoami)/.oh-my-zsh/custom && code ."

# Cordova
alias cpa="cordova plugin add"
alias cpr="cordova plugin remove"
alias cpgins="cordova plugins"  
alias cpfa="cordova platform add"
alias cpfr="cordova platform remove"

# Move paths
alias cdG="cd /Users/$(whoami)/gevity"
alias cdM="cd /Users/$(whoami)/gevity/Longevum.Models"
alias cdLT="cd /Users/$(whoami)/gevity/Longevum.Target"
alias cdLTG="cd /Users/$(whoami)/gevity/Longevum.Target.Gevity"
alias cdMDT="cd /Users/$(whoami)/gevity/MDSaaS.Target"
alias cdMDTools="cd /Users/$(whoami)/gevity/MDSaaS.tools"
alias cdMDM="cd /Users/$(whoami)/gevity/MDSaaS.Models"

function gcdp() {
  git stash
  git checkout develop
  git pull
}

function gcd() {
  git checkout develop
}

function minifyProject() {
  target="Longevum";
  here=$(pwd);
  cd "/Users/$(whoami)/gevity/MDSaaS.tools/com.mdsaas.tools/wmmin";
  node wmmin.js -no-interaction -target $target -parent -output-target $target;
  cd "/Users/$(whoami)/gevity/MDSaaS.tools/com.mdsaas.tools/wmmin";
  node wmmin.js -no-interaction -target $target -child -output-target $target;
  cd $here;
}

function Qnify() {
  target="Longevum";
  here=$(pwd);
  echo $here;
  echo $target;
  cd "/Users/$(whoami)/gevity/MDSaaS.tools/com.mdsaas.tools/wmmin";
  node wmmin.js -no-interaction -target $target -output-target $target -no-minification;
  cd $here;
}

function Fullnify() {
  here=$(pwd);  
  target="Longevum";
  compileSassGevity;
  cd "/Users/$(whoami)/gevity/MDSaaS.tools/com.mdsaas.tools/wmmin";
  node wmmin.js -no-interaction -target $target -output-target $target -no-minification;
  cd $here;
}

function compileSassGevity() {
  here=$(pwd);
  cd "/Users/$(whoami)/gevity/Longevum.Target.Gevity/com.longevum.web.gevity/app/Plugin/Gevity/webroot/css";
  sass ./main.scss ./gevity.css
  cd "/Users/$(whoami)/gevity/Longevum.Target/com.longevum.app/longevum/www/css";
  sass ./app.scss ./app.css
  cd $here;
}

function pullAll() {
  here=$(pwd);

  cdM
  gcdp

  cdLT
  gcdp

  cdLTG
  gcdp

  cdMDT
  git stash
  git checkout customer/GEV/LAMP-499
  git pull

  cdMDTools
  gcdp

  cdMDM
  gcdp

  cd $here;
}

function IFB() {
  target=${1:?"Run with target"};
  here=$(pwd);
  echo $target;
  cd "/Users/$(whoami)/gevity/Longevum.Target/com.longevum.app/";
  wmapp clean -v
  wmapp init -v
  gevbuild config /Users/$(whoami)/gevity/ ios gevity $target
  compileSassGevity
  minifyProject
  wmapp build ios
  cd $here;
}

function IQB() {
  here=$(pwd);
  cd "/Users/$(whoami)/gevity/Longevum.Target/com.longevum.app/";
  compileSassGevity
  Qnify
  wmapp build ios
  cd $here;
}

function AFB() {
  target=${1:?"Run with target"};
  here=$(pwd);

  cd "/Users/$(whoami)/gevity/Longevum.Target/com.longevum.app/";
  wmapp clean -v
  wmapp init -v
  gevbuild config /Users/$(whoami)/gevity/ android gevity $target
  compileSassGevity
  minifyProject
  wmapp build android
  adb devices
  cd $here;
  Write-Host "Build to Device: adb install /Users/$(whoami)/gevity/Longevum.Target/com.longevum.app/longevum/platforms/android/app/build/outputs/apk/debug/app-debug.apk";
  adb install "/Users/$(whoami)/gevity/Longevum.Target/com.longevum.app/longevum/platforms/android/app/build/outputs/apk/debug/app-debug.apk";
}

function AQB() {
  here=$(pwd);
  cd "/Users/$(whoami)/gevity/Longevum.Target/com.longevum.app/";
  compileSassGevity
  Qnify
  wmapp build android
  cd $here;
  adb install "/Users/$(whoami)/gevity/Longevum.Target/com.longevum.app/longevum/platforms/android/app/build/outputs/apk/debug/app-debug.apk"
}
