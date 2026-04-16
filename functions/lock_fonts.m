function lock_fonts(fig, baseFS, labelFS, legFS, cbFS)
% Keep fonts constant in point units; sizes configurable.
    if nargin==0 || ~ishandle(fig), fig = gcf; end
    % Read defaults if not provided
    if nargin<2 || isempty(baseFS),  baseFS  = get(groot,'DefaultAxesFontSize'); end
    if nargin<3 || isempty(labelFS), labelFS = baseFS + 2; end
    if nargin<4 || isempty(legFS)
        try, legFS = get(groot,'DefaultLegendFontSize'); catch, legFS = baseFS; end
    end
    if nargin<5 || isempty(cbFS)
        try, cbFS = get(groot,'DefaultColorbarFontSize'); catch, cbFS = baseFS; end
    end

    axs = findall(fig,'Type','axes');
    set(axs, 'FontUnits','points', 'FontSize', baseFS);
    for k = 1:numel(axs)
        ax = axs(k);
        if isprop(ax,'XLabel') && isprop(ax.XLabel,'FontUnits')
            ax.XLabel.FontUnits = 'points'; ax.XLabel.FontSize = labelFS;
        end
        if isprop(ax,'YLabel') && isprop(ax.YLabel,'FontUnits')
            ax.YLabel.FontUnits = 'points'; ax.YLabel.FontSize = labelFS;
        end
        if isprop(ax,'Title') && isprop(ax.Title,'FontUnits')
            ax.Title.FontUnits = 'points'; ax.Title.FontSize = labelFS;
        end
    end

    % Legend (older MATLAB: no FontUnits)
    lgd = findobj(fig,'Type','Legend');
    if ~isempty(lgd), set(lgd, 'FontSize', legFS); end

    % Colorbar (older MATLAB: no FontUnits)
    cb = findobj(fig,'Type','ColorBar');
    if ~isempty(cb), set(cb, 'FontSize', cbFS); end
end