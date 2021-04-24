# Edit Profile
alias editconf="webstorm /Users/$(whoami)/.oh-my-zsh/custom/example.zsh"

# Move paths
alias cdM="cd /Users/$(whoami)/gevity"

# Git
alias gmerge="git mergetool -Y"
alias gdiff="git difftool -Y"


function adddflt() {
  ga .
  commit "default"
  git push
}

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
