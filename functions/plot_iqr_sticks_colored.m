function plot_iqr_sticks_colored(M_pct, lo, hi, cm, custom_cmap, p_low, p_high)
% plot_iqr_sticks_colored
% IQR-style sticks between chosen percentiles + median point per cell
%
% INPUTS:
%   M_pct       : [events x cells] matrix (HI in %)
%   lo, hi      : color mapping limits (min/max for coloring)
%   cm          : colormap array (nColors x 3)
%   custom_cmap : same as cm, used for colormap()
%   p_low       : lower percentile bound (e.g., 5 or 25)
%   p_high      : upper percentile bound (e.g., 95 or 75)

% ---- Settings
cpm       = 3;
N         = size(M_pct,2);
n_modules = floor(N/cpm);

% ---- Compute percentiles
P    = prctile(M_pct, [p_low 50 p_high], 1);
p_lo = P(1,:);
p50  = P(2,:);
p_hi = P(3,:);
x     = 1:N;
nCols = size(cm,1);

% ---- Map median to color
color_idx = map_to_coloridx(p50, lo, hi, nCols);

% ---- Tick definitions
cell_ticks = [20, 40, 60, 80, N];

mod_indices = [1, 5:5:n_modules];
mod_indices = mod_indices(mod_indices ~= 35);
if mod_indices(end) ~= n_modules
    mod_indices(end+1) = n_modules;
end
mod_centers = (mod_indices - 1)*cpm + 0.5 + cpm/2;

% ---- Figure & axes
fig = figure('Color','w','Name', ...
    sprintf('Per-cell sticks (%g–%g) with median point', p_low, p_high));
ax = axes(fig);
hold(ax,'on');

% ---- Vertical grid at module boundaries
for m = 1:n_modules-1
    xsep = m*cpm + 0.5;
    line(ax, [xsep xsep], [lo hi], ...
    'Color',            [0.85 0.85 0.85], ...
    'LineStyle',        '-', ...
    'LineWidth',        0.5, ...
    'HitTest',          'off', ...
    'HandleVisibility', 'off');
end

% ---- Draw sticks
stickWidth  = 2;   capWidth  = 0.9; showCaps = true;
medianSize  = 26;  medianEdgeW = 1.0;
for i = 1:numel(x)
    if ~all(isfinite([p_lo(i) p50(i) p_hi(i)])), continue; end
    col = cm(color_idx(i),:);
    plot(ax, [x(i) x(i)], [p_lo(i) p_hi(i)], '-', 'Color', col, 'LineWidth', stickWidth, ...
    'HandleVisibility', 'off');

    line(ax, [x(i)-capWidth x(i)+capWidth], [p_lo(i) p_lo(i)], 'Color', col, 'LineWidth', stickWidth*0.6, ...
        'HandleVisibility', 'off');
    line(ax, [x(i)-capWidth x(i)+capWidth], [p_hi(i) p_hi(i)], 'Color', col, 'LineWidth', stickWidth*0.6, ...
        'HandleVisibility', 'off');
    
    plot(ax, x(i), p50(i), 'o', 'MarkerSize', medianSize/6, 'MarkerFaceColor', col, ...
        'MarkerEdgeColor', 'k', 'LineWidth', medianEdgeW, ...
        'HandleVisibility', 'off');
end

% ---- Axes style — bottom = Cell, MATLAB manages layout
xlim(ax, [0.5, N+0.5]);
ylim(ax, [-1.5, 1.5]);
set(ax, 'XTick', cell_ticks, ...
    'XTickLabel', arrayfun(@num2str, cell_ticks, 'UniformOutput', false), ...
    'TickDir', 'in', 'YAxisLocation', 'left');
xlabel(ax, '\it Cell #');
ylabel(ax, 'HI-d [%]');
box(ax,'on'); grid(ax,'off');
colormap(ax, custom_cmap); caxis(ax, [lo hi]);
cb = colorbar(ax); ylabel(cb, 'Median value');

% ---- Legend
example_col = cm(round(end/2),:);
h1 = plot(ax, NaN,NaN,'-','Color',example_col,'LineWidth',stickWidth);
h2 = plot(ax, NaN,NaN,'o','MarkerSize',medianSize/6,'MarkerFaceColor',example_col,...
    'MarkerEdgeColor','k','LineWidth',medianEdgeW);
legend(ax, [h1 h2], ...
    {sprintf('%g–%g%% percentile range', p_low, p_high), 'Median'}, ...
    'Location','best','Box','off');

% ---- Module labels drawn as text objects above the top border
module_label_handles = gobjects(0);
module_axis_handles  = gobjects(0);

    function redraw_module_axis(~,~)
        drawnow('nocallbacks');

        delete(module_label_handles(isgraphics(module_label_handles)));
        delete(module_axis_handles(isgraphics(module_axis_handles)));
        module_label_handles = gobjects(0);
        module_axis_handles  = gobjects(0);

        yl      = ylim(ax);
        y_range = yl(2) - yl(1);
        tick_len  = y_range * 0.018;
        label_gap = y_range * 0.045;
        y_top     = yl(2);

        for k = 1:numel(mod_indices)
            xk = mod_centers(k);

            hl = line(ax, [xk xk], [y_top, y_top + tick_len], ...
                'Color',            ax.XColor, ...
                'LineWidth',        0.5, ...
                'Clipping',         'off', ...
                'HandleVisibility', 'off');
            module_axis_handles(end+1) = hl;

            ht = text(ax, xk, y_top + label_gap, num2str(mod_indices(k)), ...
                'HorizontalAlignment', 'center', ...
                'VerticalAlignment',   'bottom', ...
                'FontSize',            ax.FontSize, ...
                'Clipping',            'off', ...
                'Color',               ax.XColor, ...
                'HandleVisibility',    'off');
            module_label_handles(end+1) = ht;
        end

        x_centre = mean(xlim(ax));
        ht_lbl = text(ax, x_centre, y_top + label_gap * 2.6, 'Module', ...
            'HorizontalAlignment', 'center', ...
            'VerticalAlignment',   'bottom', ...
            'FontSize',            ax.FontSize, ...
            'Clipping',            'off', ...
            'Color',               ax.XColor, ...
            'HandleVisibility',    'off');
        module_label_handles(end+1) = ht_lbl;
    end

fig.SizeChangedFcn = @redraw_module_axis;
redraw_module_axis();

end