%{
-------------------------------------
    Vladimir V. Yotov
    Te Pūnaha Ātea Space Institute
    University of Auckland

    Version: 02.02.2022
-------------------------------------

DESCRIPTION
    Recursively unpacks an input structure and deletes all object handles
    in leaf fields
    
EXT.REFS
    Baium / unpackStructure
    https://www.mathworks.com/matlabcentral/answers/
        299135-is-it-possible-to-extract-all-fields-from-a-structure-automatically
%}

function deleteStructObj(struct)

fn = fieldnames(struct);

for i = 1:numel(fn)
    fni = string(fn(i));
    field = struct.(fni);
    if isstruct(field)
        deleteStructObj(field);
        continue
    elseif isobject(field)
        delete(field);
    end
end
