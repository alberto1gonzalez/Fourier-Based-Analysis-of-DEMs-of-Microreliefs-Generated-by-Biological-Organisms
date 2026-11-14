%% ========================================================================
%% ES/ (EN)
%% Titulo/ (Title): PRIMERO_ANALISIS_DEM_MODoct26.m
%%
%% Autor/(Author): Alberto González Díez
%%
%% OBJETIVO /( Objective)
%% Analizar la estructura de un TIFF antes de ejecutar cualquier análisis-
%% -espectral. (Analyze the structure of a TIFF file before performing any 
%% spectral analysis).
%%
%% El script:
%%
%% 1. Lee el TIFF. (Reads the TIFF file.)
%% 2. Determina el número de bandas. (Determines the number of bands.)
%% 3. Muestra estadísticas de cada banda. (Displays statistics for each-
%% band.)
%% 4. Representa gráficamente cada banda. (Generates graphical-
%% representations of each band.)
%% 5. Selecciona automáticamente la banda DEM. ( Automatically selects-
%%  the DEM band.)
%%
%% Variables creadas: (the created variables are:)
%%
%% DEM
%% DEMband
%% Z
%% R
%%
%% ========================================================================

clearvars -except DEM DEMband

close all
clc

%% ========================================================================
%% SELECCION DEL TIFF (TIFF selection)
%% ========================================================================

[file,path] = uigetfile( ...
    {'*.tif;*.tiff','GeoTIFF (*.tif,*.tiff)'}, ...
    'Seleccione DEM');

if isequal(file,0)

    error('No se selecciono ningun fichero');

end

inputFile = fullfile(path,file);

%% ========================================================================
%% LECTURA (Reading)
%% ========================================================================

[Z,R] = readgeoraster(inputFile);

fprintf('\n');
fprintf('==========================================\n');
fprintf('ANALISIS DEL TIFF\n');
fprintf('==========================================\n');
fprintf('Fichero : %s\n',file);

%% ========================================================================
%% DIMENSIONES (Dimensions)
%% ========================================================================

dims = size(Z);

fprintf('\nDimensiones:\n');

disp(dims)

if ndims(Z)==2

    nBandas = 1;

else

    nBandas = size(Z,3);

end

fprintf('\nNumero de bandas detectadas: %d\n',nBandas);

%% ========================================================================
%% ANALISIS DE CADA BANDA (Analysis of each band)
%% ========================================================================

rangos = zeros(nBandas,1);

for k = 1:nBandas

    if nBandas==1

        B = Z;

    else

        B = Z(:,:,k);

    end

    fprintf('\n---------------------------------------\n');

    fprintf('BANDA %d\n',k);

    fprintf('Minimo   : %.6f\n',min(B(:)));

    fprintf('Maximo   : %.6f\n',max(B(:)));

    rango = max(B(:))-min(B(:));

    fprintf('Rango    : %.6f\n',rango);

    rangos(k) = rango;
    
    fprintf('Media    : %.6f\n',mean(B(:),'omitnan'));

    fprintf('Mediana  : %.6f\n',median(B(:),'omitnan'));

    fprintf('STD      : %.6f\n',std(B(:),'omitnan'));

    Q1 = prctile(B(:),25);

    Q3 = prctile(B(:),75);

    fprintf('Q1 (25%%) : %.6f\n',Q1);

    fprintf('Q3 (75%%) : %.6f\n',Q3);

    fprintf('NaN      : %d\n',sum(isnan(B(:))));

    figure(k)

    imagesc(B)

    axis image

    colorbar

    title(sprintf('Banda %d',k))

end

%% ========================================================================
%% SELECCION AUTOMATICA DE LA BANDA DEM (automatic DEM Band selection)
%% ========================================================================

if nBandas==1

    DEM = Z;

    DEMband = 1;

else

    maxBand = zeros(nBandas,1);

    for k = 1:nBandas

        maxBand(k) = max(Z(:,:,k),[],'all');

    end

    candidatas = find(maxBand < 1); % Para modelos normalizados o DEM sintéticos

    if ~isempty(candidatas)

        DEMband = candidatas(1);

    else

        [~,DEMband] = min(maxBand);

    end

    DEM = Z(:,:,DEMband);

end

%% ========================================================================
%% INFORME FINAL (Final Report)
%% ========================================================================

fprintf('\n');
fprintf('==========================================\n');
fprintf('BANDA DEM SELECCIONADA\n');
fprintf('==========================================\n');

fprintf('Banda : %d\n',DEMband);


fprintf('Min   : %.6f m\n',min(DEM(:),[],'omitnan'));

fprintf('Max   : %.6f m\n',max(DEM(:),[],'omitnan'));

fprintf('Rango : %.6f m\n', ...
    max(DEM(:),[],'omitnan') - ...
    min(DEM(:),[],'omitnan'));

fprintf('Media : %.6f m\n',mean(DEM(:),'omitnan'));

fprintf('Mediana : %.6f m\n',median(DEM(:),'omitnan'));

fprintf('STD     : %.6f m\n',std(DEM(:),'omitnan'));

fprintf('Q1      : %.6f m\n',prctile(DEM(:),25));

fprintf('Q3      : %.6f m\n',prctile(DEM(:),75));

fprintf('NaN   : %d\n',sum(isnan(DEM(:))));

fprintf('==========================================\n');

nNaN = sum(isnan(DEM(:)));

pctNaN = 100*nNaN/numel(DEM);

fprintf('%% NaN  : %.2f %%\n',pctNaN);


if nNaN > 0

    warning('ATENCION: El DEM contiene valores NaN. Los estadisticos utilizan omitnan.');

else

    fprintf('DEM sin valores NaN\n');

end




%% ========================================================================
%% VISUALIZACION DEL DEM DEFINITIVO (VIEWING THE FINAL DEM)
%% ========================================================================

figure(100)

imagesc(DEM)

axis image

colorbar

title(sprintf('DEM seleccionado (Banda %d)',DEMband))

%% ========================================================================
%% VARIABLES DISPONIBLES EN EL WORKSPACE (VARIABLES AVAILABLE IN THE WORKSPACE)
%% ========================================================================

disp(' ')
disp('Variables disponibles:')
disp(' ')
disp('DEM')
disp('DEMband')
disp('Z')
disp('R')
disp(' ')
disp('FIN')
