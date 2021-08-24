function [h, g] = stress_test_results_3d(DM,Tvec,Hvec)

% Call the matrix generated for different traffic levels DM
% Define a limit LIM for infinite diameter.
% Assume the length of traffics is lT
k = length(Tvec);
kk = length(Hvec);

[TT,HH] = meshgrid(Tvec,Hvec);

plottingtable = zeros(k,4);
plottingtable3d=zeros(k,4,kk);

Zeffs = zeros(k,kk);
Zeccs = zeros(k,kk);
Zdiam = zeros(k,kk);
Zhets = zeros(k,kk);

for ii = 1 : kk

for i = 1:k
    
    [a,b] = effs(DM(:,:,i,ii));
    [c,d] = diams(DM(:,:,i,ii));
    
    e = [mean(a), mean(b), mean(c), mean(d)];
    
    plottingtable(i,:) = e;
    
end
plottingtable(plottingtable == Inf) = max(max(plottingtable(plottingtable(:,3) < Inf,3)))+10;
plottingtable(isnan(plottingtable)) = 0;

plottingtable3d(:,:,ii) = plottingtable;

% FLOWS ARE COLUMNS
Zeffs(:,ii) = plottingtable3d(:,1,ii);
Zeccs(:,ii) = plottingtable3d(:,2,ii);
Zdiam(:,ii) = plottingtable3d(:,3,ii);
Zhets(:,ii) = plottingtable3d(:,4,ii);

end

% surf(TT,HH,Zeffs');
% surf(TT,HH,Zeccs');
% surf(TT,HH,Zdiam');
% surf(TT,HH,Zhets');

%Setting a white background and clean font
set(0,'DefaultFigureColor','White','defaultaxesfontsize',8,'DefaultAxesFontname','Calibri','DefaultTextFontName','Calibri')

s1 = surf(TT,HH,Zhets');
%colormap(winter(256))

%Setting the axes label, type, position, rotation, etc.
xlabel('Flow Intensity', 'fontweight', 'bold')
ylabel('IM', 'fontweight', 'bold')
zlabel('Heterogeneity', 'fontweight', 'bold')
view (135,15);
yh = get(gca,'YLabel'); % Handle of the y label
set(yh, 'Units', 'Normalized')
pos = get(yh, 'Position');
set(yh, 'Position',pos.*[0.85,0.6,1],'Rotation',-10.9)
xh = get(gca,'XLabel'); % Handle of the x label
set(xh, 'Units', 'Normalized')
pos = get(xh, 'Position');
set(xh, 'Position',pos.*[1,1,1],'Rotation',11.1)
zh = get(gca,'ZLabel'); % Handle of the z label
set(zh, 'Units', 'Normalized')
pos = get(zh, 'Position');
set(zh, 'Position',pos.*[1.5,1,0],'Rotation',90)
%title('Sample characerstic curve', 'FontSize', 12, 'fontweight', 'bold')
%Enhancing the surface characteristics
axis tight
camlight
lighting phong
shading interp
set(s1,'edgecolor',[0 0 0.4],'meshstyle','both','linewidth',.15);

end