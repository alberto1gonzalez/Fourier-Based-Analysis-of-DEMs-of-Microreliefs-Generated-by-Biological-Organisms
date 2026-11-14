%% ========================================================================
%% %% ES/ (EN)
%% Autor: Alberto González Díez
%% TERCERO_FOSIL_FILTRADO_FFT2_MOD_CUARTA_oct26.m
%% Título/ (Title):
%% ES:
%% FILTRADO FOURIER 2D BUTTERWORTH
%% OBJETIVO /(OBJECTIVE)
%%
%% ES:
%% Aplicar filtrado espectral bidimensional mediante filtros Butterworth
%% paso bajo y paso alto sobre un DEM, permitiendo generar modelos
%% filtrados y exportarlos conservando la cabecera geográfica original.
%% EN:
%% Apply two-dimensional spectral filtering using Butterworth low-pass
%% and high-pass filters on a DEM and export the resulting filtered
%% models preserving the original geographic header.
%% LECTURA DE GEOTIFF
%% RECUPERACION AUTOMATICA DE CABECERA
%% EXPORTACION A GRD ESTILO HISTORICO
%% EN:
%% 2D BUTTERWORTH FOURIER FILTER
%%
%% GEOTIFF READING
%% AUTOMATIC HEADER RECOVERY
%% EXPORT TO GRD IN HISTORICAL STYLE
%% ========================================================================

clear all
close all
clc

%% ========================================================================
%% LECTURA DEL DEM (READING THE DEM)
%% ========================================================================

[file,path] = uigetfile('*.tif','Seleccione DEM');

if isequal(file,0)

    error('No se selecciono ningun fichero');

end

inputFile = fullfile(path,file);

[Z,R] = readgeoraster(inputFile);

%% ========================================================================
%% SELECCION DE BANDA DEM (DEM BAND SELECTION)
%% ========================================================================

if ndims(Z)==3

    DEM = double(Z(:,:,1));

else

    DEM = double(Z);

end

%% ========================================================================
%% INFORMACION DEL RASTER (RASTER INFORMATION)
%% ========================================================================

ncols = size(DEM,2);

nrows = size(DEM,1);

xllcorner = R.XWorldLimits(1);

yllcorner = R.YWorldLimits(1);

cellsize = R.CellExtentInWorldX;

fprintf('\n');
fprintf('=====================================\n');
fprintf('INFORMACION DEL RASTER\n');
fprintf('=====================================\n');

fprintf('Filas      : %d\n',nrows);
fprintf('Columnas   : %d\n',ncols);

fprintf('xllcorner  : %.10f\n',xllcorner);
fprintf('yllcorner  : %.10f\n',yllcorner);

fprintf('Cellsize X : %.10f\n',R.CellExtentInWorldX);
fprintf('Cellsize Y : %.10f\n',R.CellExtentInWorldY);

fprintf('Tamano X   : %.3f m\n',ncols*cellsize);
fprintf('Tamano Y   : %.3f m\n',nrows*cellsize);

%% ========================================================================
%% CONTROL DE NaN (NaN CHECK)
%% ========================================================================

nNaN = sum(isnan(DEM(:)));

fprintf('\n');
fprintf('NaN detectados : %d\n',nNaN);

DEM(isnan(DEM)) = 0;

%% ========================================================================
%% PARAMETROS DEL FILTRO (FILTER PARAMETERS)
%% ========================================================================

COF = input('Introduzca frecuencia de corte (COF): ');

n = input('Orden Butterworth : ');

if isempty(n)

    n = 1;

end
%% ========================================================================
%% FFT2
%% ========================================================================

PQ = paddedsize(size(DEM));

F = fft2(double(DEM),PQ(1),PQ(2));



%% ========================================================================
%% FILTRO PASO ALTO (HIGH-PASS FILTER)
%% ========================================================================

H_HP = hpfilter('btw',PQ(1),PQ(2),COF,n);

F_HP = H_HP .* F;

DEM_HP = real(ifft2(F_HP));

DEM_HP = DEM_HP(1:size(DEM,1),1:size(DEM,2));

%% ========================================================================
%% FILTRO PASO BAJO (LOW-PASS FILTER)
%% ========================================================================

H_LP = lpfilter('btw',PQ(1),PQ(2),COF,n);

F_LP = H_LP .* F;

DEM_LP = real(ifft2(F_LP));

DEM_LP = DEM_LP(1:size(DEM,1),1:size(DEM,2));

%% ========================================================================
%% RELIEVE ELIMINADO (RELIEF REMOVED)
%% ========================================================================

DEM_REMOVIDO = DEM - DEM_LP;

%% ========================================================================
%% FIGURA 1
%% DEM ORIGINAL (FIGURE 1 ORIGINAL DEM)
%% ========================================================================

figure(1)

imagesc(DEM)

axis image

colorbar

title('DEM ORIGINAL')

%% ========================================================================
%% FIGURA 2
%% FILTRO PASO ALTO (HIGH-PASS FILTER)
%% ========================================================================

figure(2)

imagesc(H_HP)

axis image

colorbar

title(['FILTRO PASO ALTO COF = ' num2str(COF)])

%% ========================================================================
%% FIGURA 3
%% DEM PASO ALTO (HIGH-PASS DEM)
%% ========================================================================

figure(3)

imagesc(DEM_HP)

axis image

colorbar

title(['DEM PASO ALTO COF = ' num2str(COF)])

%% ========================================================================
%% FIGURA 4
%% DEM PASO BAJO (LOW-PASS DEM)
%% ========================================================================

figure(4)

imagesc(DEM_LP)

axis image

colorbar

title(['DEM PASO BAJO COF = ' num2str(COF)])

%% ========================================================================
%% FIGURA 5
%% RELIEVE ELIMINADO (REMOVED DEM)
%% ========================================================================

figure(5)

imagesc(DEM_REMOVIDO)

axis image

colorbar

title(['RELIEVE ELIMINADO COF = ' num2str(COF)])

%% ========================================================================
%% FIGURA 6
%% COMPARACION (COMPARISON OF THE OPTIONS)
%% ========================================================================

figure(6)

subplot(1,3,1)

imagesc(DEM)

axis image

title('ORIGINAL')

colorbar

subplot(1,3,2)

imagesc(DEM_LP)

axis image

title('PASO BAJO')

colorbar

subplot(1,3,3)

imagesc(DEM_HP)

axis image

title('PASO ALTO')

colorbar

%% ========================================================================
%% ESTADISTICAS DEM ORIGINAL (ORIGINAL STATISTICS)
%% ========================================================================

fprintf('\n');
fprintf('==============================================\n');
fprintf('DEM ORIGINAL\n');
fprintf('==============================================\n');

fprintf('Min      %.6f\n',min(DEM(:)));
fprintf('Max      %.6f\n',max(DEM(:)));
fprintf('Media    %.6f\n',mean(DEM(:)));
fprintf('Mediana  %.6f\n',median(DEM(:)));
fprintf('STD      %.6f\n',std(DEM(:)));
fprintf('Q1       %.6f\n',prctile(DEM(:),25));
fprintf('Q3       %.6f\n',prctile(DEM(:),75));

%% ========================================================================
%% ESTADISTICAS DEM PASO BAJO (STATISTICS FOR LOW-PASS DEM)
%% ========================================================================

fprintf('\n');
fprintf('==============================================\n');
fprintf('DEM PASO BAJO\n');
fprintf('==============================================\n');

fprintf('Min      %.6f\n',min(DEM_LP(:)));
fprintf('Max      %.6f\n',max(DEM_LP(:)));
fprintf('Media    %.6f\n',mean(DEM_LP(:)));
fprintf('Mediana  %.6f\n',median(DEM_LP(:)));
fprintf('STD      %.6f\n',std(DEM_LP(:)));
fprintf('Q1       %.6f\n',prctile(DEM_LP(:),25));
fprintf('Q3       %.6f\n',prctile(DEM_LP(:),75));

%% ========================================================================
%% ESTADISTICAS DEM PASO ALTO (STATISTICS FOR HIGH-PASS DEM)
%% ========================================================================

fprintf('\n');
fprintf('==============================================\n');
fprintf('DEM PASO ALTO\n');
fprintf('==============================================\n');

fprintf('Min      %.6f\n',min(DEM_HP(:)));
fprintf('Max      %.6f\n',max(DEM_HP(:)));
fprintf('Media    %.6f\n',mean(DEM_HP(:)));
fprintf('Mediana  %.6f\n',median(DEM_HP(:)));
fprintf('STD      %.6f\n',std(DEM_HP(:)));
fprintf('Q1       %.6f\n',prctile(DEM_HP(:),25));
fprintf('Q3       %.6f\n',prctile(DEM_HP(:),75));


%% ========================================================================
%% FUNCION AUXILIAR PARA LA EXPORTACIÓN A TXT 
%% (AUXILIARY FUNCTION FOR EXPORTING TO TXT)
%% ========================================================================

[~,nombre] = fileparts(file);

nombreHP = fullfile(path,...
    [nombre '_HP_COF' num2str(COF) '.txt']);

f = fopen(nombreHP,'wt');

fprintf(f,'ncols\t%d\n',ncols);
fprintf(f,'nrows\t%d\n',nrows);
fprintf(f,'xllcorner\t%.10f\n',xllcorner);
fprintf(f,'yllcorner\t%.10f\n',yllcorner);
fprintf(f,'cellsize\t%.10f\n',cellsize);
fprintf(f,'NODATA_value\t-9999\n');

fclose(f);

writematrix(DEM_HP,...
            nombreHP,...
            'Delimiter','tab',...
            'WriteMode','append');
nombreLP = fullfile(path,...
    [nombre '_LP_COF' num2str(COF) '.txt']);

f = fopen(nombreLP,'wt');

fprintf(f,'ncols\t%d\n',ncols);
fprintf(f,'nrows\t%d\n',nrows);
fprintf(f,'xllcorner\t%.10f\n',xllcorner);
fprintf(f,'yllcorner\t%.10f\n',yllcorner);
fprintf(f,'cellsize\t%.10f\n',cellsize);
fprintf(f,'NODATA_value\t-9999\n');

fclose(f);

writematrix(DEM_LP,...
            nombreLP,...
            'Delimiter','tab',...
            'WriteMode','append');

nombreREM = fullfile(path,...
    [nombre '_REMOVIDO_COF' num2str(COF) '.txt']);

f = fopen(nombreREM,'wt');

fprintf(f,'ncols\t%d\n',ncols);
fprintf(f,'nrows\t%d\n',nrows);
fprintf(f,'xllcorner\t%.10f\n',xllcorner);
fprintf(f,'yllcorner\t%.10f\n',yllcorner);
fprintf(f,'cellsize\t%.10f\n',cellsize);
fprintf(f,'NODATA_value\t-9999\n');

fclose(f);

writematrix(DEM_REMOVIDO,...
            nombreREM,...
            'Delimiter','tab',...
            'WriteMode','append');
