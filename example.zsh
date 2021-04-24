# Edit Profile
alias editconf="webstorm /Users/$(whoami)/.oh-my-zsh/custom/example.zsh"
alias openconf="cd /Users/$(whoami)/.oh-my-zsh/custom && webstorm ."

# Cordova
alias cpa="cordova plugin add"
alias cpr="cordova plugin remove"
alias cpgins="cordova plugins"
alias cpfa="cordova platform add"
alias cpfr="cordova platform remove"

# Move paths
alias cdM="cd /Users/$(whoami)/gevity"

# Git
alias gmerge="git mergetool -Y"
alias gdiff="git difftool -Y"

# Constants
G_BRANCHES=(
  /Users/$(whoami)/gevity/Longevum.Target
  /Users/$(whoami)/gevity/Longevum.Models
  /Users/$(whoami)/gevity/Longevum.Target.Gevity
  /Users/$(whoami)/gevity/MDSaaS.Target
  #/Users/$(whoami)/gevity/MDSaaS.tools
  /Users/$(whoami)/gevity/MDSaaS.Models
);

G_MASTERS=(
  "develop"
  "develop"
  "develop"
  "customer/GEV/LAMP-499"
  #"develop"
  "GEVITY"
);

# React Native
function createStore() {
  type=${1:?"Send with type"};
  cdRN;
  cd "store";
  mkdir $type:l;
  cd $type:l;
  #lower= $type:l;
  #echo $type:

  echo "export interface ${type} {
  something: string;
}

export enum ${type}ActionTypes {
  SET_$type:u = '@@$type:l/SET_$type:u',
}

export interface ${type}State {
  readonly data: ${type};
}
" > types.ts;

echo "import {Reducer} from 'redux';
import {${type}State, ${type}ActionTypes} from './types';

export const initialState: ${type}State = {
	data: {
    something: ''
	},
};

export const $type:lReducer: Reducer<${type}State> = (
	state = initialState,
	action
) => {
	const {type, payload} = action;

	switch (type) {
		case ${type}ActionTypes.SET_$type:u: {
			return {
				...state,
				data: {
					something: payload
				},
			};
		}
		default: {
			return state;
		}
	}
};
" > reducer.ts;


echo "import {${type}, ${type}ActionTypes} from './types';

export const set${type} = (data: ${type}) => {
  return {
    payload: data,
    type: ${type}ActionTypes.SET_$type:u,
  };
};
" > actions.ts;
}

# @desc   stash - checkout main - pull
function gcmp() {
  git stash
  git checkout master
  git pull
}

# @desc   checkout main
function gcm() {
  git checkout master
}

# @desc   full minification (JS)
function minifyProject() {
  target="Longevum";
  here=$(pwd);
  cd "/Users/$(whoami)/gevity/MDSaaS.tools/com.mdsaas.tools/wmmin";
  node wmmin.js -no-interaction -target $target -parent -output-target $target;
  cd "/Users/$(whoami)/gevity/MDSaaS.tools/com.mdsaas.tools/wmmin";
  node wmmin.js -no-interaction -target $target -child -output-target $target;
  cd $here;
}

# @desc   minifies child (JS)
function Qnify() {
  target="Longevum";
  here=$(pwd);
  cd "/Users/$(whoami)/gevity/MDSaaS.tools/com.mdsaas.tools/wmmin";
  node wmmin.js -no-interaction -target $target -output-target $target -no-minification;
  cd $here;
}

# @desc   minifies styles (SCSS)
function compileSassGevity() {
  here=$(pwd);
  cd "/Users/$(whoami)/gevity/Longevum.Target.Gevity/com.longevum.web.gevity/app/Plugin/Gevity/webroot/css";
  sass ./main.scss ./gevity.css
  cd "/Users/$(whoami)/gevity/Longevum.Target/com.longevum.app/longevum/www/css";
  sass ./app.scss ./app.css
  cd $here;
}

# @desc   minifies styles (SCSS) and child (JS)
function Fullnify() {
  here=$(pwd);
  target="Longevum";
  compileSassGevity;
  cd "/Users/$(whoami)/gevity/MDSaaS.tools/com.mdsaas.tools/wmmin";
  node wmmin.js -no-interaction -target $target -output-target $target -no-minification;
  cd $here;
}

# @desc   stash - checkout main - pull
function pullAll() {
  here=$(pwd);
  index=1

  for i in $G_BRANCHES[@];
  do
    cd $i
    git stash
    git checkout $G_MASTERS[$index]
    git pull
    index=$index+1
  done

  cd $here;
}

function commit() {
  message=${1:?"add a message"};
  branch=$(git branch --show-current);

  git commit -m "[$branch] $message"
}

function pullAllPreserve() {
  here=$(pwd);
  index=1

  for i in $G_BRANCHES[@];
  do
    cd $i
    git pull
    index=$index+1
  done

  cd $here;
}

# @desc   checkout to target branch
function checkoutAllExisting() {
  branch=${1:?"release/*platform*/*brand*/*environment*/*version*"};
  here=$(pwd);

  index=1

  for i in $G_BRANCHES[@];
  do
    cd $i

    git checkout $branch;

    index=$index+1
  done

  cd $here;
}

# @desc   checkout to new target branch and pushes
function checkoutAll() {
  branch=${1:?"release/*platform*/*brand*/*environment*/*version*"};
  here=$(pwd);

  index=1

  for i in $G_BRANCHES[@];
  do
    cd $i

    git checkout -b $branch;
    br=$(git branch --show-current);
    git push --set-upstream origin $br

    index=$index+1
  done

  cd $here;
}

# @desc   add - commit - push with upstream
function addnPushAll() {
  here=$(pwd);
  br=$(git branch --show-current);
  message=${1:?"Send with commit message"};
  index=1

  for i in $G_BRANCHES[@];
  do
    cd $i

    ga .
    git commit -m $message
    git push --set-upstream origin $br

    index=$index+1
  done

  cd $here;
}

# @desc   iOS full build
function IFB() {
  brand=${1:?"Run with brand"};
  target=${2:?"Run with target"};
  version=${3:-"1.0.0.0"};
  here=$(pwd);

  cd "/Users/$(whoami)/gevity/Longevum.Target/com.longevum.app/";
  wmapp clean -v
  wmapp init -v
  gevbuild config /Users/$(whoami)/gevity/ ios $brand $target $version
  compileSassGevity
  minifyProject
  wmapp build ios
  cd $here;
}

# @desc   iOS quick build
function IQB() {
  here=$(pwd);
  cd "/Users/$(whoami)/gevity/Longevum.Target/com.longevum.app/";
  compileSassGevity
  Qnify
  wmapp build ios
  cd $here;
}

# @desc   android full build
function AFB() {
  brand=${1:?"Run with brand"};
  target=${2:?"Run with target"};
  here=$(pwd);

  cd "/Users/$(whoami)/gevity/Longevum.Target/com.longevum.app/";
  wmapp clean -v
  wmapp init -v
  gevbuild config /Users/$(whoami)/gevity/ android $brand $target
  compileSassGevity
  minifyProject
  wmapp build android
  adb devices
  cd $here;
  Write-Host "Build to Device: adb install /Users/$(whoami)/gevity/Longevum.Target/com.longevum.app/longevum/platforms/android/app/build/outputs/apk/debug/app-debug.apk";
  adb install "/Users/$(whoami)/gevity/Longevum.Target/com.longevum.app/longevum/platforms/android/app/build/outputs/apk/debug/app-debug.apk";
}

# @desc   android quick build
function AQB() {
  here=$(pwd);
  cd "/Users/$(whoami)/gevity/Longevum.Target/com.longevum.app/";
  compileSassGevity
  Qnify
  wmapp build android
  cd $here;
  adb install "/Users/$(whoami)/gevity/Longevum.Target/com.longevum.app/longevum/platforms/android/app/build/outputs/apk/debug/app-debug.apk"
}
