function result = computeDNEfolder(foldername, bandwidth, Options)
    [fileNameList, suffix] = getFileNames(foldername);

    filteredFileNameList = fileNameList(~endsWith(fileNameList, '_watertight'));

    result = zeros(length(filteredFileNameList), 3);
    for i = 1:length(filteredFileNameList)
        meshname = [foldername '/' filteredFileNameList{i} suffix];
        H = ariaDNE(meshname, bandwidth, Options);
        result(i, :) = [H.DNE, H.positiveDNE, H.negativeDNE];
    end
end