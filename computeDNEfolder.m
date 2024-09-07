function result = computeDNEfolder(foldername, bandwidth, Options)
    [fileNameList, suffix] = getFileNames(foldername);

    filteredFileNameList = fileNameList(~endsWith(fileNameList, '_watertight'));

    result = zeros(length(filteredFileNameList), 6);
    for i = 1:length(filteredFileNameList)
        meshname = [foldername '/' filteredFileNameList{i} suffix];
        H = ariaDNE(meshname, bandwidth, Options);
        result(i, :) = [H.DNE, H.positiveDNE, H.negativeDNE, H.surface_area, H.positive_surface_area, H.negative_surface_area];
    end
end