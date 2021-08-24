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


%%
figure('Units', 'pixels', ...
    'Position', [100 100 500 375]);
hold on;

Data1  = stairs(H,diaF(:,2));
Data2 = stairs(H,traffic2);
Data3 = stairs(H,traffic3);
Data4 = stairs(H,traffic4);
Data5 = stairs(H,traffic5);


set(Data1                            , ...
  'LineStyle'       , '-'   , 'Color'           , [.2 .2 .2]  );

set(Data1                            , ...
  'LineWidth'       , 1           );

set(Data2                            , ...
  'LineStyle'       , '--'   , 'Color'           , [.1 .1 .1]  );

set(Data2                            , ...
  'LineWidth'       , 1           );

set(Data3                            , ...
  'LineStyle'       , '-.'   , 'Color'           , [.4 .4 .4]  );

set(Data3                            , ...
  'LineWidth'       , 1           );

set(Data4                            , ...
  'LineStyle'       , '-.'   , 'Color'           , [.6 .6 .6]  );

set(Data4                            , ...
  'LineWidth'       , 1           );

set(Data5                            , ...
  'LineStyle'       , ':'   , 'Color'           , [.7 .7 .7]  );

set(Data5                            , ...
  'LineWidth'       , 1           );




hTitle  = title ('Network Diameter \delta vs Flood Height');
hXLabel = xlabel('Flood Height (m)'                     );
hYLabel = ylabel('Network Performance Metric \delta'                      );


hLegend = legend( ...
  [Data1, Data2, Data3, Data4, Data5], ...
  '\delta_{T=1}', '\delta_{T=2}','\delta_{T=3}','\delta_{T=4}','\delta_{T=5}'  );

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
