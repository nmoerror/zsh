# Edit Profile
alias editconf='code /Users/ale/.oh-my-zsh/custom/example.zsh'

# Cordova
alias cpa='cordova plugin add'
alias cpr='cordova plugin remove'
alias cpgins='cordova plugins'  
alias cpfa='cordova platform add'
alias cpfr='cordova platform remove'

# Move paths
alias cdG='cd /Users/ale/gevity'
alias cdM='cd /Users/ale/gevity/Longevum.Models'
alias cdLT='cd /Users/ale/gevity/Longevum.Target'
alias cdLTG='cd /Users/ale/gevity/Longevum.Target.Gevity'
alias cdMDT='cd /Users/ale/gevity/MDSaaS.Target'
alias cdMDTools='cd /Users/ale/gevity/MDSaaS.tools'
alias cdMDM='cd /Users/ale/gevity/MDSaaS.Models'


function gcdp() {
  git stash
  git checkout develop
  git pull
}

function gcd() {
  git checkout develop
}

function minifyProject() {
  target='Longevum';
  here=$(pwd);
  cd "/Users/ale/gevity/MDSaaS.tools/com.mdsaas.tools/wmmin";
  node wmmin.js -no-interaction -target $target -parent -output-target $target;
  cd "/Users/ale/gevity/MDSaaS.tools/com.mdsaas.tools/wmmin";
  node wmmin.js -no-interaction -target $target -child -output-target $target;
  cd $here;
}

function Qnify() {
  target='Longevum';
  here=$(pwd);
  echo $here;
  echo $target;
  cd "/Users/ale/gevity/MDSaaS.tools/com.mdsaas.tools/wmmin";
  node wmmin.js -no-interaction -target $target -output-target $target -no-minification;
  cd $here;
}

function Fullnify() {
  here=$(pwd);  
  target='Longevum';
  compileSassGevity;
  cd "/Users/ale/gevity/MDSaaS.tools/com.mdsaas.tools/wmmin";
  node wmmin.js -no-interaction -target $target -output-target $target -no-minification;
  cd $here;
}

function compileSassGevity() {
  here=$(pwd);
  cd /Users/ale/gevity/Longevum.Target.Gevity/com.longevum.web.gevity/app/Plugin/Gevity/webroot/css
  sass ./main.scss ./gevity.css
  cd /Users/ale/gevity/Longevum.Target/com.longevum.app/longevum/www/css
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
  target=${1:?'Run with target'};
  here=$(pwd);
  echo $target;
  cd /Users/ale/gevity/Longevum.Target/com.longevum.app/
  wmapp clean -v
  wmapp init -v
  gevbuild config /Users/ale/gevity/ ios gevity $target
  compileSassGevity
  minifyProject
  wmapp build ios
  cd $here;
}

function IQB() {
  here=$(pwd);
  cd /Users/ale/gevity/Longevum.Target/com.longevum.app/
  compileSassGevity
  Qnify
  wmapp build ios
  cd $here;
}

function AFB() {
  target=${1:?'Run with target'};
  here=$(pwd);

  cd /Users/ale/gevity/Longevum.Target/com.longevum.app/
  wmapp clean -v
  wmapp init -v
  gevbuild config /Users/ale/gevity/ android gevity $target
  compileSassGevity
  minifyProject
  wmapp build android
  adb devices
  cd $here;
  Write-Host 'Build to Device: adb install "/Users/ale/gevity/Longevum.Target/com.longevum.app/longevum/platforms/android/app/build/outputs/apk/debug/app-debug.apk"'
  adb install "/Users/ale/gevity/Longevum.Target/com.longevum.app/longevum/platforms/android/app/build/outputs/apk/debug/app-debug.apk"
}

function AQB() {
  here=$(pwd);
  cd /Users/ale/gevity/Longevum.Target/com.longevum.app/
  compileSassGevity
  Qnify
  wmapp build android
  cd $here;
  adb install "/Users/ale/gevity/Longevum.Target/com.longevum.app/longevum/platforms/android/app/build/outputs/apk/debug/app-debug.apk"
}
