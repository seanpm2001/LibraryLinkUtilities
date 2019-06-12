Needs["CCompilerDriver`"];
lib = CreateLibrary[{"SharedData.cpp"}, "SharedData", options];
loadRealArray = LibraryFunctionLoad[lib, "loadRealArray", {{Real, _, "Shared"}}, "Void"];
getRealArray = LibraryFunctionLoad[lib, "getRealArray", {}, {Real, 1}];
doubleRealArray = LibraryFunctionLoad[lib, "doubleRealArray", {}, {Real, 1}];
unloadRealArray = LibraryFunctionLoad[lib, "unloadRealArray", {}, Integer];
add1 = LibraryFunctionLoad[lib, "add1", {{Real, _, "Shared"}}, "Void"];
copyShared = LibraryFunctionLoad[lib, "copyShared", {{Real, _, "Shared"}}, Integer];