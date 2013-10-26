function [ X ] = read_movielens_data( filename, usernum, itemnum)
% Load Movie Lens Data into a Matrix
    X = zeros(usernum, itemnum);
    fileID = fopen(filename);
    xs = fscanf(fileID, '%d %d %d %d', [4 inf]);
    for i=1:size(xs,2)
        X(xs(1,i),xs(2,i)) = xs(3,i);
    end
    fclose(fileID);

end

