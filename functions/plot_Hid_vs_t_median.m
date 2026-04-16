function plot_Hid_vs_t_median(Hid, p50, cm_main, lo, hi) 
% Capacity deviation vs median HI with quadrant shading and fitted line
% Points colored by median HI using the same colormap as the main plots.

% ---- Data
X = Hid;  % [%]
Y = p50;

% ---- Fixed axes and color limits
xL = [-1, 1];
yL = [lo, hi];

% ---- Figure
figure('Color','w','Name','Capacity deviation vs T_mean HI-d'); hold on

% % Quadrant shading with edges in colormap extremes
% c_low  = cm_main(1,:);        % blue side color
% c_high = cm_main(end,:);      % red side color
% 
% % Bottom-right (positive X, positive Y) → red border
% patch([0 xL(2) xL(2) 0], [0 0 yL(2) yL(2)], 0.85*c_high + 0.15, ...
%       'EdgeColor',c_high,'LineWidth',1.0,'FaceAlpha',0.05); 
% 
% % Top-left (negative X, negative Y) → blue border
% patch([xL(1) 0 0 xL(1)], [yL(1) yL(1) 0 0], 0.85*c_low + 0.15, ...
%       'EdgeColor',c_low,'LineWidth',1.0,'FaceAlpha',0.05); 

% ---- Scatter colored by median HI (Y)
nCols = size(cm_main,1);
color_idx = round((Y - lo) / (hi - lo) * (nCols - 1)) + 1;
color_idx = max(1, min(nCols, color_idx));
scatter(X, Y, 55, cm_main(color_idx,:), 'filled', ...
    'MarkerEdgeColor', 'k', 'LineWidth', 0.4);

% ---- Fit regression line (thin, gray)
p = polyfit(X, Y, 1);
xfit = linspace(xL(1), xL(2), 200);
yfit = polyval(p, xfit);
plot(xfit, yfit, '-', 'Color',[0.2 0.4 0.4], 'LineWidth', 2);

% ---- Labels & style
xlabel('HI-d [%]');
ylabel('Temperature Median [^\circC]');
xlim(xL); ylim(yL);
grid off; box off; set(gca, 'TickDir', 'in');

% ---- Colormap + colorbar
colormap(cm_main);
caxis([lo hi]);
cb = colorbar; ylabel(cb, 'Temperature Median [^\circC]');

end
