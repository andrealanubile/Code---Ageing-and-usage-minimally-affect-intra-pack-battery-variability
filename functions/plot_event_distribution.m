% function plot_event_distribution(vec, ev_idx, lo, hi, cm, nColors)
% % Figure: per-cell bars (vertical line to zero) + scatter colored by value
% figure('Name', sprintf('Event %d — HI distribution', ev_idx), 'Color', 'w'); hold on
% 
% scatter(1:numel(vec), vec, 50, vec, 'filled');
% 
% color_idx = map_to_coloridx(vec, lo, hi, nColors);
% for k = 1:numel(vec)
%     plot([k k], [0 vec(k)], 'Color', cm(color_idx(k),:), 'LineWidth', 3)
% end
% 
% xlim([1 numel(vec)]); ylim([lo hi]);
% colormap(cm); caxis([lo hi]);
% xlabel('Cell Index'); ylabel('HI [%]');
% grid off; box off; set(gca, 'TickDir', 'in', 'YAxisLocation', 'left')
% end


function plot_event_distribution(vec, ev_idx, lo, hi, cm, nColors)
    
% Figure: per-cell scatter colored by HI value
    figure('Name', sprintf('Event %d — HI distribution', ev_idx), 'Color', 'w'); hold on
    
    % Map HI values to colormap indices
    color_idx = map_to_coloridx(vec, lo, hi, nColors);
    
    % Scatter plot (each point colored according to HI)
    scatter(1:numel(vec), vec, 50, cm(color_idx,:), 'filled', ...
            'Marker','diamond');
    
    xlim([1 numel(vec)]);
    ylim([lo hi]);
    colormap(cm); caxis([lo hi]);
    
    xlabel('\it Cell #');
    ylabel('HI-d [%]');
    grid off; box off;
    set(gca, 'TickDir', 'in', 'YAxisLocation', 'left')
    
    % --- Fix X ticks: keep adaptive but enforce 1 and N
    ax = gca;
    xt = get(ax,'XTick');        % current adaptive ticks
    xt = unique([1 xt numel(vec)]);  % force 1 and last index
    set(ax,'XTick',xt);

end

