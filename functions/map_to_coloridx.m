function idx = map_to_coloridx(vals, lo, hi, nColors)
% map arbitrary values into 1..nColors with clamping
idx = round( (vals - lo) / (hi - lo) * (nColors-1) ) + 1;
idx = max(min(idx, nColors), 1);
end