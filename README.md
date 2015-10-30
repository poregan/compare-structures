# compare-structures
MATLAB function for comparing the fields in a struct datatype

## Overview
CompareStructures is a broad-stroke inspection function for the 'struct' datatype within MATLAB. 
Specifically, it will inspect two structures for equality, and if they aren't equal, it will enumerate which fields are different and which exist only in one of the two structs. If the fields are scalars, their values are displayed. Otherwise, their class and size are displayed.

## Installation
Clone the repository or download the m-file. Include the folder it resides in on MATLAB's path using `setpath()` or the Set Path icon on the Home toolbar.

## Usage
  CompareStructures(S1,S2) will display the fields and values of the two structures passed to it. It will sort them into common fields whose values match, common fields whos values differ, fields exclusive to S1, and fields exclusive to S2.

  [Feq, Fneq, FonlyS1, FonlyS2] = CompareStructures(S1,S2) will additionally return the names of those fields as cell array outputs. If a category contains no entries it will be an empty cell array. For   example, FonlyS2 = {} if S1=struct('a',1,'b',2) and S2=struct('a',5).

## Uninstallation
Delete the m-file, README.md, and License files. If you've cloned from github, you'll need to delete the .git folder too. 

## License
See the LICENSE file for details.

