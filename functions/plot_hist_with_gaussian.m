function plot_hist_with_gaussian(data, color, x_label, binWidth, xLimits, font_size)
% plot_hist_with_gaussian - Histogram with Gaussian fit overlay
%
% Inputs:
%   data      - vector of values
%   color     - [R G B] color triplet
%   binWidth  - bin width for histogram
%   xLimits   - [xmin xmax] limits for x-axis
%   font_size - size of axis 

    if nargin < 2 || isempty(color)
        color = [0 0.447 0.741]; % default blue
    end
    if nargin < 3 || isempty(binWidth)
        binWidth = (max(data) - min(data)) / 30;
    end
    if nargin < 4 || isempty(xLimits)
        xLimits = [min(data) max(data)];
    end

    % Compute Gaussian parameters
    mu = mean(data,'omitnan');
    sigma = std(data,'omitnan');

    % Histogram
    f1 = figure; hold on
    histogram(data, ...
        'FaceColor', color, ...
        'Normalization','pdf', ...
        'BinWidth', binWidth, ...
        'FaceAlpha', 0.5, ...
        'EdgeColor', 'none');

    % Gaussian fit
    x_norm = linspace(xLimits(1), xLimits(2), 200);
    y_norm = normpdf(x_norm, mu, sigma);
    plot(x_norm, y_norm, '-', 'LineWidth', 2, ...
        'Color', color, ...
        'DisplayName', sprintf('Normal fit (\\mu=%.4f, \\sigma=%.4f)', mu, sigma));

    % Labels & styling
    xlabel(x_label)
    ylabel('PDF [-]')
    xlim(xLimits)
    legend('Data','Normal fit','Location','best')
    grid off
    box on

    lock_fonts(f1,font_size,font_size,font_size,font_size)
end
