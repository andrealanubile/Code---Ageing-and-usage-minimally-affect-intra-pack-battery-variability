function set_plot_defaults_constant_font(font_size, font_name)
%SET_PLOT_DEFAULTS_CONSTANT_FONT  Lock plot fonts to a constant size.
% Usage:
%   set_plot_defaults_constant_font(16);                 % Helvetica (default)
%   set_plot_defaults_constant_font(14, 'Arial');        % custom font
%
% Notes:
% - Locks fonts to POINT units so they don’t scale with figure size.
% - Applies to new figures (root defaults) and to any existing open figures.

if nargin < 1 || isempty(font_size), font_size = 16; end
if nargin < 2 || isempty(font_name), font_name = 'Helvetica'; end

% ----- Root defaults (new figures) -----
set(0,'DefaultLineLinewidth',1.5);

% Fonts: lock to points and set sizes
set(0,'DefaultAxesFontUnits','points', 'DefaultAxesFontSize',font_size);
set(0,'DefaultTextFontUnits','points', 'DefaultTextFontSize',font_size);

% Font names
set(0,'DefaultAxesFontName',font_name);
set(0,'DefaultTextFontName',font_name);
try, set(0,'DefaultLegendFontName',font_name); end %#ok<TRYNC>
try, set(0,'DefaultColorbarFontName',font_name); end %#ok<TRYNC>

% Legend & Colorbar sizes (no FontUnits here for older MATLAB)
try, set(0,'DefaultLegendFontSize',font_size); end %#ok<TRYNC>
try, set(0,'DefaultColorbarFontSize',font_size); end %#ok<TRYNC>

% Prevent MATLAB from scaling labels/titles relative to axes size
set(0,'DefaultAxesLabelFontSizeMultiplier',1, ...
      'DefaultAxesTitleFontSizeMultiplier',1);

% Grid / box
set(0,'DefaultAxesBox','on', ...
      'DefaultAxesXGrid','on', ...
      'DefaultAxesYGrid','on', ...
      'DefaultAxesZGrid','on');

% Interpreters
set(0,'defaultTextInterpreter','tex', ...
      'defaultAxesTickLabelInterpreter','tex', ...
      'defaultlegendInterpreter','tex');

% Window style
set(0,'DefaultFigureWindowStyle','docked');

% ----- Apply to existing figures (already open) -----
figs = findall(0,'Type','figure');
for f = reshape(figs,1,[])
    % Figure children: axes, legends, colorbars
    axs = findall(f,'Type','axes');
    set(axs,'FontUnits','points','FontSize',font_size,'FontName',font_name);
    for ax = reshape(axs,1,[])
        if isprop(ax,'XLabel'), ax.XLabel.FontUnits='points'; ax.XLabel.FontSize=font_size; ax.XLabel.FontName=font_name; end
        if isprop(ax,'YLabel'), ax.YLabel.FontUnits='points'; ax.YLabel.FontSize=font_size; ax.YLabel.FontName=font_name; end
        if isprop(ax,'Title'),  ax.Title.FontUnits ='points'; ax.Title.FontSize =font_size; ax.Title.FontName =font_name;  end
    end

    lgd = findobj(f,'Type','Legend');
    if ~isempty(lgd)
        set(lgd,'FontSize',font_size,'Interpreter','tex');  %#ok<*NASGU>
        try, set(lgd,'FontName',font_name); end
    end

    cb = findobj(f,'Type','ColorBar');
    if ~isempty(cb)
        set(cb,'FontSize',font_size);
        try, set(cb,'FontName',font_name); end
    end
end
end
