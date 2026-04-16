function plot_temperature_row_percentiles(T, p_low, p_high, varargin)
% plot_temperature_row_percentiles(T, p_low, p_high, 'Name',Value,...)

% ---- Validate
if ~(isscalar(p_low) && isscalar(p_high) && p_low>=0 && p_high<=100 && p_low<p_high)
    error('p_low and p_high must satisfy 0 <= p_low < p_high <= 100.');
end
if ~isnumeric(T) || ndims(T)~=2
    error('T must be a numeric [rows x samples] matrix.');
end
N = size(T,1);

% ---- Parse options
P = inputParser;
P.addParameter('Clim',           [],           @(v)isnumeric(v)&&isempty(v)||(isvector(v)&&numel(v)==2));
P.addParameter('ColormapScheme', 'blueorange', @(s)ischar(s)||isstring(s));
P.addParameter('PastelFactor',   0.35,         @(x)isnumeric(x)&&isscalar(x)&&x>=0&&x<=1);
P.addParameter('Colormap',       [],           @(c)isnumeric(c)&&ismatrix(c)&&size(c,2)==3||isempty(c));
P.addParameter('CapWidth',       0.4,          @(x)isnumeric(x)&&isscalar(x)&&x>=0);
P.addParameter('ShowCaps',       true,         @(x)islogical(x)&&isscalar(x));
P.addParameter('MarkerSize',     4,            @(x)isnumeric(x)&&isscalar(x)&&x>0);
P.addParameter('ShadeAlpha',     0.85,         @(x)isnumeric(x)&&isscalar(x)&&x>=0&&x<=1);
P.addParameter('ColumnWidth',    0.15,         @(x)isnumeric(x)&&isscalar(x)&&x>0);
P.addParameter('Title',          '',           @(s)ischar(s)||isstring(s));
P.addParameter('CbarLabel',      'Temperature [ ^\circC]', @(s)ischar(s)||isstring(s));
P.addParameter('CellsPerModule', 3,            @(x)isnumeric(x)&&isscalar(x)&&x>=1&&mod(x,1)==0);
P.parse(varargin{:});
opt = P.Results;

cpm       = opt.CellsPerModule;
n_modules = floor(N/cpm);

% ---- Row statistics
Prc = prctile(T, [p_low 50 p_high], 2);
plo = Prc(:,1);  p50 = Prc(:,2);  phi = Prc(:,3);

% ---- y-limits
y_min = min(plo,[],'omitnan');
y_max = max(phi,[],'omitnan');
if ~isfinite(y_min)||~isfinite(y_max)||y_min==y_max
    y_min = min(T,[],'all','omitnan');
    y_max = max(T,[],'all','omitnan');
    if ~isfinite(y_min)||~isfinite(y_max)||y_min==y_max, y_min=0; y_max=1; end
end

% ---- Colormap
if isempty(opt.Colormap)
    cm = build_pastel_colormap(256, opt.ColormapScheme, opt.PastelFactor);
else
    cm = opt.Colormap;
end

% ---- Color limits
y_for_clim = [plo; phi; p50];
if isempty(opt.Clim)
    lo = prctile(y_for_clim,5,'all');  hi = prctile(y_for_clim,95,'all');
    if ~isfinite(lo)||~isfinite(hi)||lo==hi
        lo = min(y_for_clim,[],'all','omitnan'); hi = max(y_for_clim,[],'all','omitnan');
        if lo==hi, lo=lo-0.5; hi=hi+0.5; end
    end
    clim = [lo hi];
else
    clim = opt.Clim(:).';
end

% ---- Helper: value -> RGB
nCols   = size(cm,1);
val2rgb = @(v) cm(max(1,min(nCols,round((v-clim(1))/max(eps,clim(2)-clim(1))*(nCols-1))+1)),:);

% ---- Tick definitions
cell_ticks  = [20, 40, 60, 80, N];

mod_indices = [1, 5:5:n_modules];
mod_indices = mod_indices(mod_indices ~= 35);
if mod_indices(end) ~= n_modules
    mod_indices(end+1) = n_modules;
end
mod_centers = (mod_indices - 1)*cpm + 0.5 + cpm/2;

% ================================================================
% ---- Figure: let MATLAB manage layout completely
% ================================================================
fig     = figure('Color','w','Name','Temperature Row Percentiles');
ax_main = axes(fig);
hold(ax_main,'on');
halfw = opt.ColumnWidth/2;

% ---- Vertical grid at module boundaries (behind data)
for m = 1:n_modules-1
    xsep = m*cpm + 0.5;
    line(ax_main, [xsep xsep], [y_min y_max], ...
        'Color',            [0.85 0.85 0.85], ...
        'LineStyle',        '-', ...
        'LineWidth',        0.5, ...
        'HitTest',          'off', ...
        'HandleVisibility', 'off');
end

% ---- Draw bars
for i = 1:N
    if ~all(isfinite([plo(i) p50(i) phi(i)])), continue; end
    xv    = [i-halfw, i+halfw, i+halfw, i-halfw];
    yv    = [plo(i),  plo(i),  phi(i),  phi(i) ];
    cdata = [plo(i);  plo(i);  phi(i);  phi(i) ];
    patch(ax_main,'XData',xv,'YData',yv,...
          'FaceVertexCData',cdata,'FaceColor','interp',...
          'EdgeColor','none','FaceAlpha',opt.ShadeAlpha, ...
          'HandleVisibility','off');
    if opt.ShowCaps
        line(ax_main,[i-opt.CapWidth i+opt.CapWidth],[plo(i) plo(i)],...
             'Color',val2rgb(plo(i)),'LineWidth',1.2, ...
             'HandleVisibility','off');
        line(ax_main,[i-opt.CapWidth i+opt.CapWidth],[phi(i) phi(i)],...
             'Color',val2rgb(phi(i)),'LineWidth',1.2, ...
             'HandleVisibility','off');
    end
    scatter(ax_main,i,p50(i),max(20,opt.MarkerSize^2),val2rgb(p50(i)),...
            'filled','MarkerEdgeColor','none', ...
            'HandleVisibility','off');
end

% ---- Main axes style
xlim(ax_main,[0.5, N+0.5]);
ylim(ax_main,[y_min, y_max]);
ylabel(ax_main,'Temperature [ ^\circC]');
colormap(ax_main,cm); caxis(ax_main,clim);
cb = colorbar(ax_main); ylabel(cb,opt.CbarLabel);
cb.Ticks = [clim(1), mean(clim), clim(2)];
cb.TickLabels = arrayfun(@(v)sprintf('%.2f',v), cb.Ticks,'UniformOutput',false);
box(ax_main,'on'); grid(ax_main,'off');

% ---- Bottom x-axis = Cell
set(ax_main, ...
    'XTick',      cell_ticks, ...
    'XTickLabel', arrayfun(@num2str, cell_ticks, 'UniformOutput', false), ...
    'TickDir',    'in', ...
    'YAxisLocation', 'left');
xlabel(ax_main, '\it Cells');

% ================================================================
% ---- Module labels drawn as text objects above the top border
% ================================================================
module_label_handles = gobjects(0);
module_axis_handles  = gobjects(0);

    function redraw_module_axis(~,~)
        drawnow('nocallbacks');

        delete(module_label_handles(isgraphics(module_label_handles)));
        delete(module_axis_handles(isgraphics(module_axis_handles)));
        module_label_handles = gobjects(0);
        module_axis_handles  = gobjects(0);

        yl        = ylim(ax_main);
        y_range   = yl(2) - yl(1);
        tick_len  = y_range * 0.018;
        label_gap = y_range * 0.045;
        y_top     = yl(2);

        for k = 1:numel(mod_indices)
            xk = mod_centers(k);

            hl = line(ax_main, [xk xk], [y_top, y_top + tick_len], ...
                'Color',            ax_main.XColor, ...
                'LineWidth',        0.5, ...
                'Clipping',         'off', ...
                'HandleVisibility', 'off');
            module_axis_handles(end+1) = hl;

            ht = text(ax_main, xk, y_top + label_gap, num2str(mod_indices(k)), ...
                'HorizontalAlignment', 'center', ...
                'VerticalAlignment',   'bottom', ...
                'FontSize',            ax_main.FontSize, ...
                'Clipping',            'off', ...
                'Color',               ax_main.XColor, ...
                'HandleVisibility',    'off');
            module_label_handles(end+1) = ht;
        end

        x_centre = mean(xlim(ax_main));
        ht_lbl = text(ax_main, x_centre, y_top + label_gap * 2.6, 'Module', ...
            'HorizontalAlignment', 'center', ...
            'VerticalAlignment',   'bottom', ...
            'FontSize',            ax_main.FontSize, ...
            'Clipping',            'off', ...
            'Color',               ax_main.XColor, ...
            'HandleVisibility',    'off');
        module_label_handles(end+1) = ht_lbl;
    end

fig.SizeChangedFcn = @redraw_module_axis;
redraw_module_axis();

end

% ================================================================
% ---------- helper ----------
% ================================================================
function cm = build_pastel_colormap(n, scheme, pastel_factor)
if mod(n,2)~=0, n = n+1; end
t1 = linspace(0,1,n/2)';
t2 = linspace(0,1,n/2)';
switch lower(string(scheme))
    case "blueorange"
        half1 = [0+(1.0-0)*t1,  0.4+(0.6-0.4)*t1,  1.0+(0.0-1.0)*t1];
        half2 = [1.0+(1-1)*t2,  0.6+(0.2-0.6)*t2,  0.0+(0-0)*t2    ];
    case "greenorange"
        half1 = [0.0+(1-0)*t1,  0.7+(0.6-0.7)*t1,  0.0+(0-0)*t1    ];
        half2 = [1.0+(1-1)*t2,  0.6+(0.2-0.6)*t2,  0.0+(0-0)*t2    ];
    otherwise
        error('Unknown ColormapScheme. Use ''blueorange'' or ''greenorange''.');
end
cm_vivid = [half1; half2];
cm = min(1, cm_vivid + (1-cm_vivid)*pastel_factor);
end