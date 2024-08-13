function varargout = CompareStructures(S1, S2)
% COMPARESTRUCTURES Lists differences in fields of two structures
%  CompareStructures(S1,S2) will display the fields and values of the two
%    structures passed to it. It will sort them into common fields whose
%    values match, common fields whos values differ, fields exclusive to
%    Structure 1, and fields exclusive to Structure 2. 
%  [Feq, Fneq, FonlyS1, FonlyS2] = CompareStructures(S1,S2) will
%  additionally return the names of those fields as cell array outputs.
%
%  If a category contains no entries it will be an empty cell array. For
%  example, FonlyS2 = {} if S1=struct('a',1,'b',2) and S2=struct('a',5).
%
% v1.1 (Agust 13, 2024)
% - Will attempt to convert objects to STRUCT to improve utility
% - Will treat NaN as equal.
% 
%
% Author: Peter O'Regan (peteroregan@gmail.com)
% Last Revised: August 13, 2024
%
% Copyright © 2015-2024 Peter R. O'Regan
% See LICENSE at https://github.com/poregan/compare-structures
%

narginchk(2,2);
nargoutchk(0,4);

if isobject(S1)
    S1 = struct(S1);
end
if isobject (S2)
    S2 = struct(S2);
end

if ~isstruct(S1) || ~isstruct(S2)
    error('CompareStructs:BadInputType','One or more arguments is not a structure or convertible object.');
end

if isequaln(S1,S2)
    fprintf('The structures are identical.\n');
    if nargout > 0, varargout{1} = fieldnames(S1); end
    return
end

fS1 = fieldnames(S1);
fS2 = fieldnames(S2);
fic = intersect(fS1,fS2);
match = [];
nomatch = [];

for i=1:length(fic)
    if isequaln(S1.(fic{i}),S2.(fic{i}))
        match(end+1) = i; %#ok<AGROW>
    else
        nomatch(end+1) = i; %#ok<AGROW>
    end
end

if ~isempty(fic)
    if ~isempty(match)
        fprintf('The following shared fields match in value:\n');
        for ix=1:numel(match)
            fprintf('  %-15s\t',fic{match(ix)});
            if isscalar(S1.(fic{match(ix)})) && isnumeric(S1.(fic{match(ix)}))
                fprintf('%s\n',num2str(S1.(fic{match(ix)})));
            else
                fprintf('%s %s\n',SizeAsString(S1.(fic{match(ix)})),class(S1.(fic{match(ix)})));
            end
        end
    else
        fprintf('    << NO SHARED FIELDS MATCH IN VALUE>>\n');
    end

    fprintf('\n\nThe following shared fields do not match in value:\n');
    if ~isempty(nomatch)    
        for ix=1:numel(nomatch)
            fprintf('  %-15s\t',fic{nomatch(ix)});
            if isscalar(S1.(fic{nomatch(ix)})) && isnumeric(S1.(fic{nomatch(ix)}))
                fprintf('%-10s\t',num2str(S1.(fic{nomatch(ix)})));
                fprintf('%-10s\n',num2str(S2.(fic{nomatch(ix)})));
            else
                fprintf('%s %s\t',SizeAsString(S1.(fic{nomatch(ix)})),class(S1.(fic{nomatch(ix)})));
                fprintf('%s %s\n',SizeAsString(S2.(fic{nomatch(ix)})),class(S2.(fic{nomatch(ix)})));
            end
        end   
    else
        fprintf('    << ALL SHARED FIELDS MATCH IN VALUE>>\n');
    end
else
    fprintf('There are no shared fields.\n');
end
s1only = setdiff(fS1,fic);
fprintf('\n\nThe following fields are in S1 only:\n')
if ~isempty(s1only)
    for ix=1:numel(s1only)
        fprintf('  %-15s\t',s1only{ix});
        if isscalar(S1.(s1only{ix})) && isnumeric(S1.(s1only{ix}))
            fprintf('%-10s\n',num2str(S1.(s1only{ix})));
        else
            fprintf('%s %s\n',SizeAsString(S1.(s1only{ix})),class(S1.(s1only{ix})));
        end
    end  
else
    fprintf('    << S1 HAS NO UNIQUE FIELDS >>\n');
end
s2only = setdiff(fS2,fic);
fprintf('\n\nThe following fields are in S2 only:\n')
if ~isempty(s2only)
    for ix=1:numel(s2only)
        fprintf('  %-15s\t',s2only{ix});
        if isscalar(S2.(s2only{ix})) && isnumeric(S2.(s2only{ix}))
            fprintf('%-10s\n',num2str(S2.(s2only{ix})));
        else
            fprintf('%s %s\n',SizeAsString(S2.(s2only{ix})),class(S2.(s2only{ix})));
        end
    end  
else
    fprintf('    << S2 HAS NO UNIQUE FIELDS >>\n');
end
fprintf('\n');

%Output section
if nargout > 0
    varargout{1} = fic(match);
end
if nargout > 1
    varargout{2} = fic(nomatch);
end
if nargout > 3
    varargout{3} = s1only;
end
if nargout > 0
    varargout{4} = s2only;
end

end

function str = SizeAsString(elem)
%Helper function to enumerate the [AxBxC] size style.
vec = size(elem);
if isscalar(vec)
    str = ['[' num2str(vec) ']'];
    return
else
    str = num2str(vec(1));
    if length(vec) > 1
        for i=2:length(vec)
            str = [str 'x' num2str(vec(i))]; %#ok<AGROW>
        end
    end
end
str = ['[' str ']'];
end



