function [DeltaSOC_mean, DeltaSOC_std, datetime_values] = computeDeltaSOCStats(DeltaSOC_LC, corr_value, Day_end)
    DeltaSOC_std = [];
    DeltaSOC_mean = [];
    datetime_values = datetime.empty;
    for i = 1:length(corr_value)
        DeltaSOC_std(end+1) = std(DeltaSOC_LC(i, :));
        DeltaSOC_mean(end+1) = mean(DeltaSOC_LC(i, :));
        datetime_values(end+1, 1) = Day_end(i);
    end
end
