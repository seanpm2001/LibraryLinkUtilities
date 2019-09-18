(* Wolfram Language Test file *)
TestRequirement[$VersionNumber >= 12.0];
(***************************************************************************************************************************************)
(*
	Set of test cases to test LLU functionality related to handling and exchanging Strings
*)
(***************************************************************************************************************************************)
TestExecute[
	Needs["CCompilerDriver`"];
	currentDirectory = DirectoryName[$CurrentFile];

	(* Get configuration (path to LLU sources, compilation options, etc.) *)
	Get[FileNameJoin[{ParentDirectory[currentDirectory], "TestConfig.wl"}]];

	(* Compile the test library *)
	lib = CCompilerDriver`CreateLibrary[
		FileNameJoin[{currentDirectory, "TestSources", #}]& /@ {"String.cpp"},
		"StringTest",
		options (* defined in TestConfig.wl *)
	];

	Get[FileNameJoin[{$LLUSharedDir, "LibraryLinkUtilities.wl"}]];
];

ExactTest[
	EchoString = LibraryFunctionLoad[lib, "EchoString", { LibraryDataType[String] }, LibraryDataType[String]];
	EchoString["foo bar"]
	,
	"foo bar"	
	,
	TestID->"StringOperations-20150807-D1D4K5"
];

ExactTest[
	Greetings = LibraryFunctionLoad[lib, "Greetings", {"UTF8String"}, "UTF8String"];
	Greetings["wolfram"]
	,
	"Greetings wolfram!"
	,
	TestID->"StringOperations-20150807-X0R7U9"
];

ExactTest[
	HelloWorld = LibraryFunctionLoad[lib, "HelloWorld", {}, "UTF8String"];
	HelloWorld[]
	,
	"Hello World"
	,
	TestID->"StringOperations-20150807-K4Y4G8"
];

ExactTest[
	CapitalizeFirst = LibraryFunctionLoad[lib, "CapitalizeFirst", {"UTF8String"}, "UTF8String"];
	CapitalizeFirst["hello World"]
	,
	"Hello World"
	,
	TestID->"StringTestSuite-20180821-Y4A0E2"
];

Test[
	CapitalizeAll = LibraryFunctionLoad[lib, "CapitalizeAll", {"UTF8String"}, "UTF8String"];
	CapitalizeAll["Hello World"]
	,
	ToUpperCase["Hello World"]
	,
	TestID->"StringTestSuite-20180821-X0K5Z1"
];

Test[
	RoundTripCString = LibraryFunctionLoad[lib, "RoundTripCString", {"UTF8String"}, "UTF8String"];
	RoundTripString = LibraryFunctionLoad[lib, "RoundTripString", {"UTF8String"}, "UTF8String"];

	largeString = StringJoin @ RandomChoice[Alphabet[], 100000000];

	timeCString = First @ RepeatedTiming[Do[RoundTripCString[largeString], 5];];
	Print["C-string time: " <> ToString[timeCString]];

	timeString = First @ RepeatedTiming[Do[RoundTripString[largeString], 5];];
	Print["std::string time: " <> ToString[timeString]];
	
	Clear[largeString];
	
	timeString >= timeCString (* Not a very reliable unit test, don't worry too much if it fails *)
	,
	True
	,
	TestID->"StringTestSuite-20180821-Y0C3Q1"
];

Test[
	StrLength = LibraryFunctionLoad[lib, "StringLength", { LibraryDataType[String] }, LibraryDataType[Integer]];
	StrLength["this is my null terminated string"]
	,
	33
	,
	TestID->"StringOperations-20150813-B8G3E7"
];
