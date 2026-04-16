function [normalized_matrix, ref_row] = normalizeColorInfo(color_info_matrix)
    ref_row = mean(color_info_matrix(1:100, :), 1);
    normalized_matrix = color_info_matrix - ref_row;
end
