Class {
	#name : #SindarinStepCommand,
	#superclass : #SindarinCommand,
	#category : #'NewTools-Sindarin-Commands'
}

{ #category : #'accessing - defaults' }
SindarinStepCommand class >> defaultDescription [
	^ 'Step in'
]

{ #category : #'accessing - defaults' }
SindarinStepCommand class >> defaultIconName [
	^#glamorousInto
]

{ #category : #'accessing - defaults' }
SindarinStepCommand class >> defaultName [
	^ 'Step'
]

{ #category : #hooks }
SindarinStepCommand >> execute [
	self context model step.
	self context refresh.
]
