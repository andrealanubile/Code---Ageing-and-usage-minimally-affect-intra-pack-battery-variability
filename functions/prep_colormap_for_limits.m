function [cm, nColors] = prep_colormap_for_limits(custom_cmap, lo, hi, N)
% interpolate custom_cmap to N rows over the display range [lo, hi]
nColors = N;
cm      = interp1(linspace(lo, hi, size(custom_cmap,1)), custom_cmap, ...
                  linspace(lo, hi, nColors), 'linear', 'extrap');
end