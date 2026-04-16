function color_info_matrix = computeColorInfoMatrix(DeltaSOC_LC, DeltaSOC_mean, valid_indices)
    num_cells = size(DeltaSOC_LC, 2);
    num_events = length(valid_indices);
    color_info_matrix = NaN(num_events, num_cells);
    for idx = 1:num_events
        i = valid_indices(idx);
        DeltaSOC_row = DeltaSOC_LC(i, :);
        mean_val = DeltaSOC_mean(i);
        color_info_matrix(idx, :) = ( mean_val - DeltaSOC_row) ./ mean_val;
    end
end
