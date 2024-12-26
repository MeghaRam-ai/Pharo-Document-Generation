Class {
	#name : 'DocumentationGeneratorTest',
	#superclass : 'TestCase',
	#instVars : [
		'obj',
		'testPackage'
	],
	#category : 'PharoSeasideDoc',
	#package : 'PharoSeasideDoc'
}

{ #category : 'basic tests' }
DocumentationGeneratorTest >> getMockPackage [
	"Set a package for testing"

	"scope: class-variables  &  instance-variables"
	obj setPackageName: 'MenuRegistration'

]

{ #category : 'running' }
DocumentationGeneratorTest >> setUp [

	super setUp.
	obj := DocumentationGenerator new.
	testPackage := self getMockPackage
]

{ #category : 'tests' }
DocumentationGeneratorTest >> testextractInstanceVariables [
	"scope: class-variables  &  instance-variables"

	| package classes methods pragmaMenuBuilder instanceVariableNames |
	package := Smalltalk image packages detect: [ :p |
		           p name = obj packageName ].

	classes := package definedClasses.
	pragmaMenuBuilder := classes detect: [ :cls |
		                     cls name = 'PragmaMenuBuilder' ].
	instanceVariableNames := pragmaMenuBuilder instanceVariables
		                         collect: [ :var | var name ].
	self assert: instanceVariableNames size identicalTo: 3.
	self assert: (instanceVariableNames includes: 'model')
]

{ #category : 'tests' }
DocumentationGeneratorTest >> testextractMethodData [
	"scope: class-variables  &  instance-variables"

	| package classes methods |
	package := Smalltalk image packages detect: [ :p |
		           p name = obj packageName ].

	classes := package definedClasses.
	methods := classes flatCollect: #methods.
	self assert: methods size > 0
]

{ #category : 'tests' }
DocumentationGeneratorTest >> testloadClassMetadata [
	"scope: class-variables  &  instance-variables"

	| package |
	package := Smalltalk image packages detect: [ :p |
		           p name = obj packageName ].
	self assert: package isNotNil
]

{ #category : 'tests' }
DocumentationGeneratorTest >> testloadClassMetadataForDefineClasses [
	"scope: class-variables  &  instance-variables"

	| package classes |
	package := Smalltalk image packages detect: [ :p |
		           p name = obj packageName ].
	classes := package definedClasses.
	self assert: classes isNotNil.
	self assert: classes size identicalTo: 7
]

{ #category : 'tests' }
DocumentationGeneratorTest >> testsetPackageName [
	"Test if package name setter working"

	"scope: class-variables  &  instance-variables"

	obj setPackageName: 'TestPackage'.
	self assert: obj packageName equals: 'TestPackage'
]
