%% Plot default
% Linewidth
set(0,'DefaultLineLinewidth',1.5);

% Fontsize for axes
set(0,'DefaultAxesFontSize',16);

% Grid and Box
set(0, 'DefaultAxesBox', 'on');
set(0,'DefaultAxesXGrid','on',...
    'DefaultAxesYGrid','on',...
    'DefaultAxesZGrid','on');

% Latex interpreter: label, tick, legend 
set(0,'defaultTextInterpreter','tex');
set(0,'defaultAxesTickLabelInterpreter','tex');
set(0,'defaultlegendInterpreter','tex');

% Window Style
set(0,'DefaultFigureWindowStyle','docked');
% f = gcf; f.WindowStyle = 'normal'; pause(1); f.Position = [500 300 800 450];