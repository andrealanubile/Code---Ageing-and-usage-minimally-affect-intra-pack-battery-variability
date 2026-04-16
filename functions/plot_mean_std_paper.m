% function plot_mean_std_paper(y_mean, y_std, x_label, y_label, x, color)
% % plot_mean_std_paper
% % Plots mean ± 3σ over time, split at Jul-31-2024.
% % - Same color for both intervals
% % - Gray “gap” rectangles drawn first (not included in legend)
% % - y-limits proportional to the data
% % - Minimal legend: only ±3σ and μ
% 
%     % -------- Settings --------
%     last_date   = datetime(2025,8,24);     % force axis to end here
%     cutoff_date = datetime(2024,7,31);     % split intervals here
%     if nargin < 6 || isempty(color), color = [0 0.447 0.741]; end
% 
%     % -------- Coerce shapes & equal length --------
%     y_mean = y_mean(:);
%     y_std  = y_std(:);
%     if isdatetime(x)
%         x_num = datenum(x(:));   % datetick expects datenum
%         is_dt = true;
%     else
%         x_num = x(:);
%         is_dt = false;
%     end
%     L = min([numel(x_num), numel(y_mean), numel(y_std)]);
%     x_num = x_num(1:L);
%     y_mean = y_mean(1:L);
%     y_std  = y_std(1:L);
% 
%     % -------- Compute bounds --------
%     y_upper = y_mean + 3*y_std;
%     y_lower = y_mean - 3*y_std;
% 
%     figure('Color','w'); hold on;
% 
%     if is_dt
%         cutoffnum = datenum(cutoff_date);
% 
%         % Masks for intervals
%         idx1 = x_num <= cutoffnum;
%         idx2 = x_num >  cutoffnum;
% 
%         % Finite mask
%         finiteAll = isfinite(x_num) & isfinite(y_mean) & isfinite(y_upper) & isfinite(y_lower);
%         maskAll   = (idx1 | idx2) & finiteAll;
% 
%         % y-limits from data
%         if any(maskAll)
%             ylo = min(y_lower(maskAll));
%             yhi = max(y_upper(maskAll));
%             span = yhi - ylo;
%             pad  = 0.05 * (span + (span==0)*max(1e-6,abs(yhi)*0.05));
%             ylo = ylo - pad; 
%             yhi = yhi + pad;
%         else
%             ylo = 0; yhi = 1;
%         end
% 
%         % ================= GRAY GAPS FIRST =================
%         gray  = [0.85 0.85 0.85]; alpha = 0.35;
% 
%         % Between intervals
%         if any(idx1) && any(idx2)
%             end1 = max(x_num(idx1));
%             beg2 = min(x_num(idx2));
%             if isfinite(end1) && isfinite(beg2) && beg2 > end1
%                 fill([end1, beg2, beg2, end1], [ylo, ylo, yhi, yhi], ...
%                      gray, 'EdgeColor','none', 'FaceAlpha', alpha, ...
%                      'HandleVisibility','off');
%             end
%         end
% 
%         % Tail to axis end
%         if any(finiteAll)
%             last_data = max(x_num(finiteAll));
%             xend = datenum(last_date);
%             if isfinite(last_data) && xend > last_data
%                 fill([last_data, xend, xend, last_data], [ylo, ylo, yhi, yhi], ...
%                      gray, 'EdgeColor','none', 'FaceAlpha', alpha, ...
%                      'HandleVisibility','off');
%             end
%         end
%         % ===================================================
% 
%         % ---------- SEGMENT 1 ----------
%         if any(idx1)
%             xn1 = x_num(idx1).'; yu1 = y_upper(idx1).'; yl1 = y_lower(idx1).'; ym1 = y_mean(idx1).';
%             m1 = isfinite(xn1)&isfinite(yu1)&isfinite(yl1)&isfinite(ym1);
%             xn1=xn1(m1); yu1=yu1(m1); yl1=yl1(m1); ym1=ym1(m1);
% 
%             if numel(xn1) >= 2
%                 fill([xn1, fliplr(xn1)], [yu1, fliplr(yl1)], color, ...
%                      'EdgeColor','none', 'FaceAlpha', 0.30, 'DisplayName','±3σ');
%             end
%             if ~isempty(xn1)
%                 plot(xn1, ym1, '-o', 'Color', color,'MarkerSize', 2,'MarkerFaceColor', color, ...
%                      'LineWidth', 1, 'DisplayName','μ');
%             end
%         end
% 
%         % ---------- SEGMENT 2 ----------
%         if any(idx2)
%             xn2 = x_num(idx2).'; yu2 = y_upper(idx2).'; yl2 = y_lower(idx2).'; ym2 = y_mean(idx2).';
%             m2 = isfinite(xn2)&isfinite(yu2)&isfinite(yl2)&isfinite(ym2);
%             xn2=xn2(m2); yu2=yu2(m2); yl2=yl2(m2); ym2=ym2(m2);
% 
%             if numel(xn2) >= 2
%                 fill([xn2, fliplr(xn2)], [yu2, fliplr(yl2)], color, ...
%                      'EdgeColor','none', 'FaceAlpha', 0.30, 'HandleVisibility','off');
%             end
%             if ~isempty(xn2)
%                 plot(xn2, ym2, '-o', 'Color', color, 'MarkerSize', 2 ,'MarkerFaceColor', color, ...
%                      'LineWidth', 1, 'HandleVisibility','off');
%             end
%         end
% 
%         % Axes
%         xlim([min(x_num), datenum(last_date)]);
%         ylim([ylo, yhi]);
%         datetick('x', 'mmm-yy', 'keeplimits');
% 
%         % Minimal legend: just ±3σ and μ
%         legend('show','Location','best');
% 
%     else
%         % Numeric x (no split, no gaps)
%         x = x_num(:).'; 
%         yu = (y_mean+3*y_std).'; 
%         yl = (y_mean-3*y_std).'; 
%         ym = y_mean.';
% 
%         m = isfinite(x)&isfinite(yu)&isfinite(yl)&isfinite(ym);
%         x=x(m); yu=yu(m); yl=yl(m); ym=ym(m);
% 
%         if numel(x) >= 2
%             fill([x, fliplr(x)], [yu, fliplr(yl)], color, ...
%                  'EdgeColor','none','FaceAlpha',0.30, 'DisplayName','±3σ');
%         end
%         if ~isempty(x)
%             plot(x, ym, '-o','Color',color,'MarkerFaceColor',color,'LineWidth',2, ...
%                  'DisplayName','μ');
%         end
% 
%         if ~isempty(x)
%             ylo = min(yl); yhi = max(yu);
%             span = yhi - ylo;
%             pad  = 0.05 * (span + (span==0)*max(1e-6,abs(yhi)*0.05));
%             ylim([ylo - pad, yhi + pad]);
%         end
% 
%         legend('show','Location','best');
%     end
% 
%     xlabel(x_label);
%     ylabel(y_label);
%     grid off;
% end

function plot_mean_std_paper(y_mean, y_std, x_label, y_label, x, color, font_size)
% plot_mean_std_paper
% Plots mean ± 3σ over time, split at Jul-31-2024.
% - Same color for both intervals
% - Gray “gap” rectangles drawn first (not included in legend)
% - y-limits proportional to the data
% - Minimal legend: only ±3σ (error bar) and μ (mean line)

    % -------- Settings --------
    last_date   = datetime(2025,8,24);     % force axis to end here
    cutoff_date = datetime(2024,7,31);     % split intervals here
    if nargin < 6 || isempty(color), color = [0 0.447 0.741]; end

    % -------- Coerce shapes & equal length --------
    y_mean = y_mean(:);
    y_std  = y_std(:);
    if isdatetime(x)
        x_num = datenum(x(:));   % datetick expects datenum
        is_dt = true;
    else
        x_num = x(:);
        is_dt = false;
    end
    L = min([numel(x_num), numel(y_mean), numel(y_std)]);
    x_num = x_num(1:L);
    y_mean = y_mean(1:L);
    y_std  = y_std(1:L);

    % -------- Compute bounds --------
    y_upper = y_mean + 3*y_std;
    y_lower = y_mean - 3*y_std;

    f1 = figure('Color','w'); hold on;

    if is_dt
        cutoffnum = datenum(cutoff_date);

        % Masks for intervals
        idx1 = x_num <= cutoffnum;
        idx2 = x_num >  cutoffnum;

        % Finite mask
        finiteAll = isfinite(x_num) & isfinite(y_mean) & isfinite(y_upper) & isfinite(y_lower);
        maskAll   = (idx1 | idx2) & finiteAll;

        % y-limits from data
        if any(maskAll)
            ylo = min(y_lower(maskAll));
            yhi = max(y_upper(maskAll));
            span = yhi - ylo;
            pad  = 0.05 * (span + (span==0)*max(1e-6,abs(yhi)*0.05));
            ylo = ylo - pad; 
            yhi = yhi + pad;
        else
            ylo = 0; yhi = 1;
        end

        % ================= GRAY GAPS FIRST =================
        gray  = [0.85 0.85 0.85]; alpha = 0.35;
        if any(idx1) && any(idx2)
            end1 = max(x_num(idx1));
            beg2 = min(x_num(idx2));
            if isfinite(end1) && isfinite(beg2) && beg2 > end1
                fill([end1, beg2, beg2, end1], [ylo, ylo, yhi, yhi], ...
                     gray, 'EdgeColor','none', 'FaceAlpha', alpha, ...
                     'HandleVisibility','off');
            end
        end
        if any(finiteAll)
            last_data = max(x_num(finiteAll));
            xend = datenum(last_date);
            if isfinite(last_data) && xend > last_data
                fill([last_data, xend, xend, last_data], [ylo, ylo, yhi, yhi], ...
                     gray, 'EdgeColor','none', 'FaceAlpha', alpha, ...
                     'HandleVisibility','off');
            end
        end

        % ---------- SEGMENT 1 ----------
        if any(idx1)
            xn1 = x_num(idx1).'; yu1 = y_upper(idx1).'; yl1 = y_lower(idx1).'; ym1 = y_mean(idx1).';
            m1 = isfinite(xn1)&isfinite(yu1)&isfinite(yl1)&isfinite(ym1);
            xn1=xn1(m1); yu1=yu1(m1); yl1=yl1(m1); ym1=ym1(m1);

            if numel(xn1) >= 2
                % shaded area: hide from legend
                fill([xn1, fliplr(xn1)], [yu1, fliplr(yl1)], color, ...
                     'EdgeColor','none', 'FaceAlpha', 0.15, 'HandleVisibility','off');
            end
            if ~isempty(xn1)
                errNeg1 = ym1 - yl1;
                errPos1 = yu1 - ym1;
                % error bars: show in legend once
                hE1 = errorbar(xn1, ym1, errNeg1, errPos1, ...
                    'LineStyle','none', 'Color', color, 'CapSize', 3, ...
                    'LineWidth',0.5, 'DisplayName','±3\sigma');
                % mean markers: show as μ
                hM1 = plot(xn1, ym1, 'o', 'Color', color,'MarkerSize',3, ...
                           'MarkerFaceColor', color, 'LineWidth',1, ...
                           'DisplayName','\mu');
                try, uistack(hE1,'down',1); end %#ok<TRYNC>
                try, uistack(hM1,'top');   end %#ok<TRYNC>
            end
        end

        % ---------- SEGMENT 2 ----------
        if any(idx2)
            xn2 = x_num(idx2).'; yu2 = y_upper(idx2).'; yl2 = y_lower(idx2).'; ym2 = y_mean(idx2).';
            m2 = isfinite(xn2)&isfinite(yu2)&isfinite(yl2)&isfinite(ym2);
            xn2=xn2(m2); yu2=yu2(m2); yl2=yl2(m2); ym2=ym2(m2);

            if numel(xn2) >= 2
                fill([xn2, fliplr(xn2)], [yu2, fliplr(yl2)], color, ...
                     'EdgeColor','none', 'FaceAlpha', 0.15, 'HandleVisibility','off');
            end
            if ~isempty(xn2)
                errNeg2 = ym2 - yl2;
                errPos2 = yu2 - ym2;
                % error bars segment 2: hidden from legend (legend already has entry)
                hE2 = errorbar(xn2, ym2, errNeg2, errPos2, ...
                    'LineStyle','none', 'Color', color, 'CapSize', 3, ...
                    'LineWidth',0.5, 'HandleVisibility','off');
                hM2 = plot(xn2, ym2, 'o', 'Color', color,'MarkerSize',3, ...
                           'MarkerFaceColor', color, 'LineWidth',1, ...
                           'HandleVisibility','off');
                try, uistack(hE2,'down',1); end %#ok<TRYNC>
                try, uistack(hM2,'top');   end %#ok<TRYNC>
            end
        end

        xlim([min(x_num), datenum(last_date)]);
        ylim([ylo, yhi]);
        datetick('x', 'mmm-yy', 'keeplimits');

        legend('show','Location','best');

    else
        % Numeric x branch
        x = x_num(:).'; yu = (y_mean+3*y_std).'; yl = (y_mean-3*y_std).'; ym = y_mean.';
        m = isfinite(x)&isfinite(yu)&isfinite(yl)&isfinite(ym);
        x=x(m); yu=yu(m); yl=yl(m); ym=ym(m);

        if numel(x) >= 2
            fill([x, fliplr(x)], [yu, fliplr(yl)], color, ...
                 'EdgeColor','none','FaceAlpha',0.15, 'HandleVisibility','off');
        end
        if ~isempty(x)
            errNeg = ym - yl;
            errPos = yu - ym;
            hEn = errorbar(x, ym, errNeg, errPos, ...
                'LineStyle','none', 'Color', color, 'CapSize', 3, ...
                'LineWidth',0.5, 'DisplayName','±3\sigma');
            hMn = plot(x, ym, 'o','Color',color,'MarkerFaceColor',color,'LineWidth',1, ...
                 'DisplayName','\mu','MarkerSize',3);
            try, uistack(hEn,'down',1); end %#ok<TRYNC>
            try, uistack(hMn,'top');   end %#ok<TRYNC>
        end

        if ~isempty(x)
            ylo = min(yl); yhi = max(yu);
            span = yhi - ylo;
            pad  = 0.05 * (span + (span==0)*max(1e-6,abs(yhi)*0.05));
            ylim([ylo - pad, yhi + pad]);
        end

        legend('show','Location','best');
    end

    xlabel(x_label);
    ylabel(y_label);
    grid off;

    lock_fonts(f1,font_size,font_size,font_size,font_size);
end

