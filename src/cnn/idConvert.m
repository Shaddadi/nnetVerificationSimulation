%id = (i, j, d) denotes the id of row, column, depth
% row, depth denotes row's length(row's = column's) and depth
% convert 3d id to 1d id
function new_id = idConvert(id, row, depth)
    new_id = (id(1)-1)*row*depth + (id(2)-1)*depth + id(3); % corresponding the flatten function in keras
end