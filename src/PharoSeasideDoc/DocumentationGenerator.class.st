"
DocumentationGenerator
"
Class {
	#name : 'DocumentationGenerator',
	#superclass : 'WAComponent',
	#instVars : [
		'packageName',
		'ClassMetaData'
	],
	#category : 'PharoSeasideDoc',
	#package : 'PharoSeasideDoc'
}

{ #category : 'class initialization' }
DocumentationGenerator class >> initialize [
	"comment stating purpose of instance-side method"
	"scope: class-variables  &  instance-variables"
	self register .
]

{ #category : 'initialization' }
DocumentationGenerator class >> register [
	"comment stating purpose of instance-side method"
	"scope: class-variables  &  instance-variables"
	WAAdmin register: self asApplicationAt: 'documentation'.
	WAAdmin defaultDispatcher defaultName: 'documentation'.
]

{ #category : 'hooks' }
DocumentationGenerator class >> style [
	"comment stating purpose of class-side method"
	"scope: class-variables  &  class-instance-variables"

	'body { font-family: Arial; } .parent-font { color: blue; } .subclass-font { color: green; }'
]

{ #category : 'accessing' }
DocumentationGenerator >> classMetaData [

	^ ClassMetaData 
]

{ #category : 'initialization' }
DocumentationGenerator >> classMetaData: anObject [

	ClassMetaData := anObject
]

{ #category : 'operation' }
DocumentationGenerator >> extractInstanceVariables: class [
	"This function extracts instance variables of a class given a class name"

	"scope: class-variables  &  instance-variables"

	| instanceVariableNames |
	instanceVariableNames := OrderedCollection new.
	class instanceVariables do: [ :ins |
		instanceVariableNames add: ins name ].
	^ instanceVariableNames
]

{ #category : 'operating' }
DocumentationGenerator >> extractMethodData: class [
	"This function extracts the details of methods used inside a class"

	"scope: class-variables  &  instance-variables"

	| methodData |
	methodData := OrderedCollection new.
	class methods do: [ :aMethod |
		| classMethodData |
		classMethodData := Dictionary new.
		classMethodData at: #methodName put: aMethod selector.
		classMethodData at: #methodComment put: aMethod comment.
		methodData add: classMethodData ].
	^ methodData
]

{ #category : 'operation' }
DocumentationGenerator >> loadClassMetadata [
	"This is the main class to process a package and extract information about
	itself and the containing methods, varibales etc"

	| package classes metaData |
	[
	package := Smalltalk image packages detect: [ :p |
		           p name = packageName ] ]
		on: Exception
		do: [ ^ self ].

	classes := package definedClasses.
	ClassMetaData := OrderedCollection new.

	classes do: [ :cl |
		metaData := Dictionary new.
		metaData at: #className put: cl name.
		metaData at: #childClasses put: cl subclasses.
		metaData at: #superClass put: cl superclass.
		metaData at: #comment put: cl comment.
		metaData
			at: #instanceVariables
			put: (self extractInstanceVariables: cl).
		metaData at: #methodDetails put: (self extractMethodData: cl).
		ClassMetaData add: metaData ]
]

{ #category : 'accessing' }
DocumentationGenerator >> packageName [

	^ packageName
]

{ #category : 'accessing' }
DocumentationGenerator >> packageName: aString [

	packageName := aString
]

{ #category : 'rendering' }
DocumentationGenerator >> renderContentOn: html [
	"Main rendering of package details as the contents of html"

	html form: [
		html text: 'Package Name: '.
		html textInput on: #packageName of: self.
		html break.
		html break.
		html submitButton
			callback: [ self loadClassMetadata ];
			with: 'Genrate Documentation' ].

	ClassMetaData isEmptyOrNil ifTrue: [ ^ self ].
	html div
		class: 'box-out';
		with: [
			html unorderedList: [
					ClassMetaData do: [ :classData |
							html listItem: [
									html heading level2 with:
											'Class: ' , (classData at: #className).
									html
										text: 'Parent: ';
										text: (classData at: #superClass);
										break;
										break.

									(classData at: #childClasses) ifNotEmpty: [ :childClasses |
										html
											strong: 'Direct Known Subclasses: ';
											strong: (String streamContents: [ :stream |
														 childClasses do: [ :each |
																 stream
																	 nextPutAll: each asString;
																	 nextPutAll: ', ' ] ]);
											break;
											break ].

									html horizontalRule.
									html
										text: 'Class ';
										strong: (classData at: #className);
										text: ' child of ';
										text: (classData at: #superClass);
										break;
										break.
									html text: (classData at: #comment).


									html div
										class: 'box';
										with: [
											html heading level3 with: 'Field Summary '.
											html table: [
													html tableColumn: [
															html tableHeading: 'Fields'.
															(classData at: #instanceVariables) do: [ :var |
																	html tableRow: [ html tableData: var asString ] ] ] ] ] ].
							html div
								class: 'box';
								with: [
									html heading level3 with: 'Method Summary '.
									html table: [
											html tableRow: [
													html tableHeading: 'Method Name'.
													html tableHeading: 'Method description'.

													(classData at: #methodDetails) do: [ :data |
															html tableRow: [
																	html tableData: (data at: #methodName) asString.
																	html tableData: (data at: #methodComment) asString ] ] ] ] ] ] ] ]
]

{ #category : 'initialization' }
DocumentationGenerator >> setPackageName: aPackageName [
	"Initialise the package name"
	"scope: class-variables  &  instance-variables"

	self packageName: aPackageName 
]

{ #category : 'accessing' }
DocumentationGenerator >> style [
	"main css style file"

	^ 'table { width: 100%; 
			background-color: #9CB9BF; 
			margin: 20px 0;
        	font-size: 16px;
        	text-align: left;
	}
		th, td {
        padding: 12px;
        border: 1px solid #ddd;
    }

    th {
        background-color: #f4f4f4;
        font-weight: bold;
    }

    tr:nth-child(odd) {
        background-color: #f9f9f9;
    }

    tr:hover {
        background-color: #f1f1f1;
    }
	
	form {
    margin: 20px auto;               
    background-color: #F5A206;       
    padding: 20px;                 
    width: 80%;                     
    max-width: 600px;                
    box-sizing: border-box;         
    display: block;                 
    margin-left: auto;               
    margin-right: auto;              
    word-wrap: break-word;           
    border-radius: 8px;              
    text-align: center;              
	}

	.box {
        background-color: #F0EEEB;        
        padding: 20px;                     
        border-radius: 8px;                
        margin: 20px 0;                    
    }
	.box-out {
        background-color: #EAF1F1;        
        padding: 20px;                      
        margin: 20px 0;                    
    }
   
	'
]
