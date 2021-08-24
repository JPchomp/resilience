%%plot all


diaF = [];

for i = 1:k
    
DiametersF=mean(FMATS(:,:,i));
diaF(i,1)=mean(DiametersF);
    
effsF=(1./mean(FMATS(:,:,i)));
effF(i,1)=mean(effsF);

eccsF=std(FMATS(:,:,i));
eccF(i,1)=mean(eccsF);

hetsF=(1./std(FMATS(:,:,i)));
hetF(i,1)=mean(hetsF);

end


for i = 1:k
    
DiametersF=mean(FMATSSP(:,:,i));
diaF(i,2)=mean(DiametersF);
    
effsF=(1./mean(FMATSSP(:,:,i)));
effF(i,2)=mean(effsF);

eccsF=std(FMATSSP(:,:,i));
eccF(i,2)=mean(eccsF);

hetsF=(1./std(FMATSSP(:,:,i)));
hetF(i,2)=mean(hetsF);

end

diaF(diaF==0) = 3;
diaF(diaF == Inf) = 3;

figure('Units', 'pixels', ...
    'Position', [100 100 500 375]);
hold on;

Data  = stairs(H,diaF(:,1));
Data2 = stairs(H,diaF(:,2));


set(Data                            , ...
  'LineStyle'       , '--'   , 'Color'           , [.2 .2 .2]  );

set(Data                            , ...
  'LineWidth'       , 1           );

set(Data2                            , ...
  'LineStyle'       , '-'   , 'Color'           , [.1 .1 .1]  );

set(Data2                            , ...
  'LineWidth'       , 1           );

hTitle  = title ('Network Diameter \delta vs Flood Height');
hXLabel = xlabel('Flood Height (m)'                     );
hYLabel = ylabel('Network Performance Metric \delta'                      );


hLegend = legend( ...
  [Data, Data2], ...
  '\delta_{mc}', '\delta_{sp}' );

set( gca                       , ...
    'FontName'   , 'Helvetica' );
set( gcf                       , ...
    'color'   , 'w' );
set([hTitle, hXLabel, hYLabel], ...
    'FontName'   , 'AvantGarde');
set([hLegend, gca]             , ...
    'FontSize'   , 8           );
set([hXLabel, hYLabel]  , ...
    'FontSize'   , 10          );
set( hTitle                    , ...
    'FontSize'   , 12          , ...
    'FontWeight' , 'bold'      );

set(gca, ...
  'Box'         , 'off'     , ...
  'TickDir'     , 'out'     , ...
  'TickLength'  , [.02 .02] , ...
  'XMinorTick'  , 'on'      , ...
  'YMinorTick'  , 'on'      , ...
  'YGrid'       , 'on'      , ...
  'XColor'      , [.3 .3 .3], ...
  'YColor'      , [.3 .3 .3], ...
  'YTick'       , 0:0.5:5, ...
  'LineWidth'   , 1);
