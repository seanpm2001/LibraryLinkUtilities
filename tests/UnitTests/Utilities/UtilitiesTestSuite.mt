(* Wolfram Language Test file *)
TestRequirement[$VersionNumber >= 12.0];
(***************************************************************************************************************************************)
(*
	Set of test cases to test LLU functionality related to Managed Library Expressions
*)
(***************************************************************************************************************************************)
TestExecute[
	Needs["CCompilerDriver`"];
	currentDirectory = DirectoryName[$CurrentFile];

	(* Get configuration (path to LLU sources, compilation options, etc.) *)
	Get[FileNameJoin[{ParentDirectory[currentDirectory], "TestConfig.wl"}]];

	(* Compile the test library *)
	lib = CCompilerDriver`CreateLibrary[
		FileNameJoin[{currentDirectory, "TestSources", #}]& /@ {"UtilitiesTest.cpp"},
		"Utilities",
		options
	];

	Get[FileNameJoin[{$LLUSharedDir, "LibraryLinkUtilities.wl"}]];

	RegisterPacletErrors[lib, <||>];

	`LLU`Logger`PrintLogFunctionSelector := Block[{`LLU`Logger`FormattedLog = `LLU`Logger`LogToShortString},
		`LLU`Logger`PrintLogToSymbol[LogSymbol][##]
	]&;


	$OpenRead = SafeLibraryFunction["OpenForReading", {String}, Integer];
	$OpenWrite = SafeLibraryFunction["OpenForWriting", {String}, Integer];
	$OpenInvalidMode = SafeLibraryFunction["OpenInvalidMode", {String}, Integer];

	f = FileNameJoin[{$TemporaryDirectory, "some_file_that-hopefully-does_not_exist"}];

	topSecretFile = If[$OperatingSystem === "Windows", "C:\\Windows\\system.ini", "/etc/passwd"]
];

TestExecute[
	DeleteFile[f];
];

TestMatch[
	$OpenRead @ f
	,
	Failure["OpenFileFailed", <|
		"MessageTemplate" -> "Could not open file `f`.",
		"MessageParameters" -><|"f" -> f|>,
		"ErrorCode" -> _?CppErrorCodeQ,
		"Parameters" -> {}
	|>]
	,
	TestID -> "UtilitiesTestSuite-20190718-I7S1K0"
];

Test[
	$OpenWrite @ f
	,
	0
	,
	TestID -> "UtilitiesTestSuite-20191221-T0X0K0"
];

Test[
	$OpenRead @ f
	,
	0
	,
	TestID -> "UtilitiesTestSuite-20191221-P3Q0Q8"
];

TestMatch[
	$OpenInvalidMode @ f
	,
	Failure["InvalidOpenMode", <|
		"MessageTemplate" -> "Specified open mode is invalid.",
		"MessageParameters" -> <||>,
		"ErrorCode" -> _?CppErrorCodeQ,
		"Parameters" -> {}
	|>]
	,
	TestID -> "UtilitiesTestSuite-20191221-M2O8P0"
];

TestMatch[
	$OpenWrite @ topSecretFile
	,
	Failure["OpenFileFailed", <|
		"MessageTemplate" -> "Could not open file `f`.",
		"MessageParameters" -><|"f" -> topSecretFile|>,
		"ErrorCode" -> _?CppErrorCodeQ,
		"Parameters" -> {}
	|>]
	,
	TestID -> "UtilitiesTestSuite-20191221-T5I6L4"
];