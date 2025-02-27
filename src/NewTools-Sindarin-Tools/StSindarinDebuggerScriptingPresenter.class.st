"
I am a StDebugger extension for scripting the developer's debugging session.
I provides ways to:
- write a live script directly in the debugger (and affecting the debug session)
- save/load scripts
- create debugging commands from scripts

My owner must be a spec debugger
"
Class {
	#name : #StSindarinDebuggerScriptingPresenter,
	#superclass : #SpPresenter,
	#traits : 'TStDebuggerExtension',
	#classTraits : 'TStDebuggerExtension classTrait',
	#instVars : [
		'code',
		'resultInspection',
		'toolbar',
		'sindarinDebugger'
	],
	#category : #'NewTools-Sindarin-Tools'
}

{ #category : #layout }
StSindarinDebuggerScriptingPresenter class >> defaultLayout [
	^ SpBoxLayout newTopToBottom
		add: #toolbar expand: false;
		add: #code;
		add: 'Result (right click to see more...)' 
			expand: false 
			fill: false 
			padding: 5;
		add: #resultInspection;
		yourself
]

{ #category : #actions }
StSindarinDebuggerScriptingPresenter >> createCommandFromScript [
	self flag: 'todo'
]

{ #category : #'debugger extension' }
StSindarinDebuggerScriptingPresenter >> debuggerExtensionToolName [

	^ 'Sindarin'
]

{ #category : #actions }
StSindarinDebuggerScriptingPresenter >> executeScript [
	| stream result model receiver evaluationContext |
	self debugger removeSessionHolderSubscriptions.
	stream := code text readStream.
	model := code interactionModel.
	receiver := model context receiver.
	evaluationContext := model context.
	result := receiver class compiler
		          source: stream;
		          context: evaluationContext;
		          receiver: receiver;
		          requestor: model;
		          failBlock: [ nil ];
		          evaluate.
	resultInspection model: result.
	resultInspection update.
	self debugger setSessionHolderSubscriptions.
	self debugger forceSessionUpdate
]

{ #category : #initialization }
StSindarinDebuggerScriptingPresenter >> initializePresenters [
	code := self newCode.
	code interactionModel: StSindarinContextInteractionModel new.
	code syntaxHighlight: true.
	"code contextMenu: [  ]."
	code text: 'sindarin stepOver'.
	self updateCode.
	self flag: 'Build a generic sindarin script class with sidnarin as an instance var and its instance should be the receiver of the code'.
	self flag: 'set the doit conetxt of the code to the current selected context'.
	resultInspection := nil inspectionRaw.
	resultInspection owner: self.
	self initializeToolbar
]

{ #category : #initialization }
StSindarinDebuggerScriptingPresenter >> initializeToolbar [
	toolbar := self newToolbar.
	toolbar addStyle: 'stToolbar'.
	toolbar beIcons.
	SpToolbarPresenterBuilder new
		toolbarPresenter: toolbar;
		visit: self toolbarActions
]

{ #category : #actions }
StSindarinDebuggerScriptingPresenter >> loadScript [
	self flag: 'todo'
]

{ #category : #actions }
StSindarinDebuggerScriptingPresenter >> removeScriptCommand [
	self flag: 'todo'
]

{ #category : #actions }
StSindarinDebuggerScriptingPresenter >> saveScript [
	self flag: 'todo'
]

{ #category : #accessing }
StSindarinDebuggerScriptingPresenter >> setModelBeforeInitialization: aStDebugger [
	"My original model is the debugger presenter that I extend"
	debugger := aStDebugger.
	sindarinDebugger := aStDebugger sindarinDebugger
]

{ #category : #accessing }
StSindarinDebuggerScriptingPresenter >> sindarin [
	^sindarinDebugger 
]

{ #category : #building }
StSindarinDebuggerScriptingPresenter >> toolbarActions [
	| group |
	group := (CmCommandGroup named: 'Toolbar') asSpecGroup.
	
	group register: (SindarinRunScriptCommand forSpecContext: self).
	group register: (SindarinSaveScriptCommand forSpecContext: self).
	group register: (SindarinLoadScriptCommand forSpecContext: self).
	group register: (SindarinCreateCommandFromScriptCommand forSpecContext: self).
	group register: (SindarinRemoveCommandCommand forSpecContext: self).

	
	^ group
]

{ #category : #initialization }
StSindarinDebuggerScriptingPresenter >> updateCode [
	code interactionModel context: self debugger currentContext.
	code interactionModel bindings
		at: #sindarin
		put: (WorkspaceVariable key: #sindarin value: self sindarin)
]

{ #category : #initialization }
StSindarinDebuggerScriptingPresenter >> updatePresenter [ 	
	self updateCode.
	super updatePresenter 
]
