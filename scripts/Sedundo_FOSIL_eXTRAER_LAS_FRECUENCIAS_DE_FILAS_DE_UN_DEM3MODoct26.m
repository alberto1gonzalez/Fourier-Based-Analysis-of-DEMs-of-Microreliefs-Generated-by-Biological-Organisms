%% ========================================================================
%% ES/ (EN)
%% Título/ (Title):
%% "Sedundo_FOSIL_eXTRAER_LAS_FRECUENCIAS_DE_FILAS_DE_UN_DEM3MODoct26.m"
%%
%% Autor/(Author):  Alberto González Díez
%%
%% PROPÓSITO/ (AIM)
%%
%% Este script mantiene la metodología histórica empleada en los trabajos
%% previos para identificar frecuencias de corte (COF) mediante FFT 1D.
%% (This script follows the historical methodology used in-
%% previous studies to identify cut-off frequencies or COF using 1D FFT.)
%% ES:
%% La frecuencia relativa clásica se conserva para garantizar la comparación
%% con resultados anteriores
%% Como mejora metodológica se incorporan:
%% 1.- Frecuencias espaciales reales (ciclos/m)
%% 2.- Longitudes de onda (m)
%% 3.- Doble eje X:
%%      inferior --> frecuencia relativa clásica
%%      superior --> frecuencia espacial real
%% 4.- Exportación ampliada a Excel
%% ========================================================================
%% EL SCRIPT PROCEDE DE OTRO DENOMINADO 
%% Sedundo_FOSIL_eXTRAER_LAS_FRECUENCIAS_DE_FILAS_DE_UN_DEM.m
%% Y ESTE EVOLUCIONÓ A OTROS DOS MODIFICACIONES POSTERIORES:
%% Sedundo_FOSIL_eXTRAER_LAS_FRECUENCIAS_DE_FILAS_DE_UN_DEMMODoct26.m
%%  Y Sedundo_FOSIL_eXTRAER_LAS_FRECUENCIAS_DE_FILAS_DE_UN_DEM2MODoct26.m
%% LA ULTIMA, ES UN SCRIPT PARA: FFT_1D_ANALISIS_FRECUENCIAL_DEM
%% Este script realiza un análisis espectral unidimensional mediante la
%% Transformada Rápida de Fourier (FFT) aplicado a un Modelo Digital de
%% Elevaciones (MDE) DIRECTAMENTE DEL TIF.
%% El script original fue desarrollado para obtener la distribución de
%% energía frecuencial de una señal topográfica lineal, permitiendo
%% identificar frecuencias dominantes presentes en el relieve y facilitando
%% la selección posterior de frecuencias de corte para procesos de filtrado.
%% En esta versión se mantiene íntegramente el procedimiento original de
%% cálculo de la FFT y de representación del espectro de amplitud.
%%
%% MODIFICACIÓN INTRODUCIDA
%%
%% El script original utilizaba:
%%
%%      Fs = L;
%%
%% donde Fs representaba únicamente un índice frecuencial relacionado con
%% el tamaño de la señal.
%%
%% En la presente versión Fs se define empleando el tamaño real de celda
%% del MDE:
%%
%%      dx = 0.001 m
%%      Fs = 1/dx = 1000 ciclos/m
%%
%% De este modo las frecuencias obtenidas dejan de ser índices abstractos
%% y pasan a representar frecuencias espaciales reales expresadas en:
%%
%%      ciclos por metro (ciclos/m)
%%
%% permitiendo una interpretación geomorfológica directa.
%%
%% Asimismo se calcula:
%%
%%      lambda = 1./f
%%
%% obteniéndose las longitudes de onda reales asociadas a cada frecuencia.
%%
%% APLICACIÓN
%%
%% El objetivo principal de este análisis no es sustituir la transformada
%% bidimensional (FFT2) aplicada al MDE, sino caracterizar previamente las
%% periodicidades lineales presentes en el modelo topográfico para ayudar
%% a seleccionar frecuencias de corte adecuadas en posteriores procesos de
%% filtrado espectral 2D.
%%
%% Flujo de trabajo:
%%
%%      MDE
%%          ↓
%%      Vectorización
%%          ↓
%%      FFT 1D
%%          ↓
%%      Identificación de frecuencias dominantes
%%          ↓
%%      Selección de frecuencias de corte
%%          ↓
%%      FFT2 y filtrado espectral bidimensional
%%
%% %% EN:
%% The traditional relative frequency is retained to ensure comparability
%% with previous results
%% The following methodological improvements have been incorporated:
%% 1. Actual spatial frequencies (cycles/m)
%% 2. Wavelengths (m)
%% 3. Dual X-axis:
%%      lower --> traditional relative frequency
%%      upper --> actual spatial frequency
%% 4. Extended export to Excel)
%% ========================================================================
%% THIS SCRIPT IS DERIVED FROM ANOTHER ONE CALLED
%% Sedundo_FOSIL_eXTRAER_LAS_FRECUENCIAS_DE_FILAS_DE_UN_DEM.m
%% AND THIS EVOLVED INTO TWO FURTHER MODIFICATIONS:
%% Sedundo_FOSIL_eXTRAER_LAS_FRECUENCIAS_DE_FILAS_DE_UN_DEMMODoct26.m
%%  And Sedundo_FOSIL_extract_frequencies_from_rows_of_a_DEM2MODoct26.m
%% THE LATEST ONE IS A SCRIPT FOR: FFT_1D_FREQUENCY_ANALYSIS_DEM
%%
%% This script performs a one-dimensional spectral analysis using the
%% Fast Fourier Transform (FFT) applied to a Digital Elevation
%% Model (DEM) DIRECTLY FROM THE TIF FILE.
%%
%% The original script was developed to obtain the distribution of
%% frequency energy of a linear topographic signal, enabling
%% the identification of dominant frequencies present in the terrain and facilitating
%% the subsequent selection of cut-off frequencies for filtering processes.
%%
%% This version fully retains the original procedure for
%% calculating the FFT and plotting the amplitude spectrum.
%%
%% CHANGE MADE
%%
%% The original script used:
%%
%%      Fs = L;
%%
%% where Fs represented only a frequency index related to
%% the signal size.
%%
%% In this version, Fs is defined using the actual cell size
%% of the DEM:
%%
%%      dx = 0.001 m
%%      Fs = 1/dx = 1000 cycles/m
%%
%% In this way, the frequencies obtained cease to be abstract indices
%% and come to represent actual spatial frequencies expressed in:
%%
%%      cycles per metre (cycles/m)
%%
%% allowing for a direct geomorphological interpretation.
%%
%% The following is also calculated:
%%
%%      lambda = 1./f
%%
%% yielding the actual wavelengths associated with each frequency.
%%
%% APPLICATION
%%
%% The main objective of this analysis is not to replace the
%% two-dimensional transform (FFT2) applied to the DEM, but rather to 
%% characterise in advance the linear periodicities present in the 
%% topographic model to assist in selecting appropriate cut-off
%%  frequencies in subsequent
%% 2D spectral filtering processes.
%%
%% Workflow:
%%
%%      MDE
%%          ↓
%%      Vectorisation
%%          ↓
%%      1D FFT
%%          ↓
%%      Identification of dominant frequencies
%%          ↓
%%      Selection of cut-off frequencies
%%          ↓
%%      2D FFT and two-dimensional spectral filtering
%% ========================================================================
%% ========================================================================

clear all
close all
clc

%% ========================================================================
%% LECTURA DEL DEM (DEM READING)
%% ========================================================================

[file,path] = uigetfile('*.tif','Seleccione DEM GeoTIFF');

if isequal(file,0)
    error('No se seleccionó ningún fichero');
end

inputFile = fullfile(path,file);

[Z,R] = readgeoraster(inputFile);

%% ========================================================================
%% SELECCIÓN DE BANDA DEM (DEM BAND SELECTION)
%% ========================================================================

if ndims(Z)==3

    fprintf('\n');
    fprintf('Raster multibanda detectado\n');
    fprintf('Seleccionando banda DEM = Banda 1\n');

    DEM = Z(:,:,1);

else

    DEM = Z;

end
fprintf('\n');
fprintf('Comprobacion DEM\n');
fprintf('Minimo : %.6f\n',min(DEM(:)));
fprintf('Maximo : %.6f\n',max(DEM(:)));

if max(DEM(:)) > 1
    warning('El DEM presenta valores superiores a 1 m. Revisar la banda seleccionada.');
end

%% ========================================================================
%% INFORMACIÓN DEL DEM (INFORMATION FROM THE DEM)
%% ========================================================================


fprintf('\n');

fprintf('DEM leído correctamente\n');

fprintf('Filas     : %d\n',size(DEM,1));

fprintf('Columnas  : %d\n',size(DEM,2));

fprintf('Z mínima  : %.6f\n',min(DEM(:)));

fprintf('Z máxima  : %.6f\n',max(DEM(:)));

%% ========================================================================
%% ELIMINACION DE NaN (ElIMINATION of NaN)
%% ========================================================================
DEM(isnan(DEM)) = 0;


%% ========================================================================
%% CONVERSIÓN A VECTOR (CONVERSION TO A 1D VECTOR)
%% ========================================================================
y = DEM(:);
fprintf('\n');
fprintf('NaN sustituidos por 0 para FFT\n');
%% ========================================================================
%% PARÁMETROS DEL SCRIPT HISTÓRICO (HISTORICAL SCRIPT PARAMETERS)
%% ========================================================================

N = length(y);

L = 2^nextpow2(N);

%% ========================================================================
%% FRECUENCIA RELATIVA CLÁSICA (CLASSICAL RELATIVE FREQUENCY)
%% ========================================================================

Fs = L;

Ts = 1/Fs;

t = (0:L-1).*Ts;

%% ========================================================================
%% FRECUENCIA ESPACIAL REAL (FRECUENCIA ESPACIAL REAL)
%% ========================================================================

dx = 0.001;              % tamaño de pixel (m)

Fs_real = 1/dx;          % ciclos/m

%% ========================================================================
%% FFT
%% ========================================================================

c = fft(y);

C = abs(fft(y));

c0 = abs(fft(y,L));

c1 = c0(1:L/2);

cima = imag(fft(y));

cFima = fftshift(imag(fft(y)));

cFimac = fftshift(abs(fft(y)/L));

%% ========================================================================
%% ESPECTRO NORMALIZADO (NORMALISED SPECTRUM)
%% ========================================================================

cFimacent = abs(c(1:L/2)/L);

cFimacent2 = 2*abs(c(1:L/2)/L);

%% ========================================================================
%% FRECUENCIA RELATIVA HISTÓRICA (HISTORICAL RELATIVE FREQUENCY)
%% ========================================================================

f_rel = Fs*(0:(L/2)-1)/L;

%% ========================================================================
%% FRECUENCIA ESPACIAL REAL (ACTUAL SPATIAL FREQUENCY)
%% ========================================================================

f_real = Fs_real*(0:(L/2)-1)/L;

%% ========================================================================
%% LONGITUD DE ONDA (WAVELENGTH)
%% ========================================================================

lambda = 1./f_real;

lambda(1)=Inf;

%% ========================================================================
%% FIGURA 7
%% HISTÓRICA
%% ========================================================================

figure(7)

plot(f_rel,cFimacent2)

title('Fig.7 Frecuencia relativa vs amplitud')

xlabel('Frecuencia relativa')

ylabel('Amplitud')

grid on

%% ========================================================================
%% FIGURA 8
%% HISTÓRICA
%% ========================================================================

figure(8)

plot(f_rel,cFimacent2)

title('Fig.8 Frecuencia relativa vs amplitud')

xlabel('Frecuencia relativa')

ylabel('Amplitud')

ax = gca;

ax.XLim = [0 500];

grid on

%% ========================================================================
%% FIGURA 9
%% HISTÓRICA
%% ========================================================================

figure(9)

plot(f_rel,cFimacent2)

title('Fig.9 Frecuencia relativa vs amplitud')

xlabel('Frecuencia relativa')

ylabel('Amplitud')

ax = gca;

ax.XLim = [0 30];

grid on

%% ========================================================================
%% FIGURA 10
%% FRECUENCIA ESPACIAL REAL (ACTUAL SPATIAL FREQUENCY)
%% ========================================================================

figure(10)

plot(f_real,cFimacent2,'k')

title('Frecuencia espacial real vs amplitud')

xlabel('Frecuencia espacial (ciclos/m)')

ylabel('Amplitud')

ax = gca;

ax.XLim = [0 20];

grid on

%% ========================================================================
%% FIGURA 11
%% LONGITUD DE ONDA (WAVELENGTH)
%% ========================================================================

figure(11)

plot(lambda,cFimacent2)

title('Longitud de onda vs amplitud')

xlabel('Longitud de onda (m)')

ylabel('Amplitud')

xlim([0 0.20])

grid on

%% ===============================================================
%% FIGURA 12 MEJORADA
%% FRECUENCIA RELATIVA + FRECUENCIA REAL (RELATIVE FREQUENCY + ACTUAL FREQUENCY)
%% ===============================================================

figure(12)
clf

%% ---------------------------------------------------------------
%% EJE PRINCIPAL (MAIN AXIS)
%% ---------------------------------------------------------------

ax1 = axes;

plot(f_rel,cFimacent2,...
     'k',...
     'LineWidth',1.5)

grid on

xlabel('Frecuencia relativa')

ylabel('Amplitud')


xlim([0 30])

%% ---------------------------------------------------------------
%% EJE SUPERIOR (UPPER AXIS)
%% ---------------------------------------------------------------

ax2 = axes;

ax2.Position = ax1.Position;

ax2.Color = 'none';

ax2.XAxisLocation = 'top';

ax2.YTick = [];

ax2.Box = 'off';

ax2.XLim = ax1.XLim;

ticks_rel = 0:5:30;

ticks_real = ticks_rel .* (max(f_real)/max(f_rel));

ax2.XTick = ticks_rel;

ax2.XTickLabel = string(round(ticks_real,2));

xlabel(ax2,'Frecuencia espacial real (ciclos/m)')


%% ========================================================================
%% EXPORTACIÓN AMPLIADA A EXCEL (EXPORT TO EXCEL)
%% ========================================================================

ind = f_rel <= 500;

frel_exp = f_rel(ind);

freal_exp = f_real(ind);

lambda_exp = lambda(ind);

amp_exp = cFimacent2(ind);

M = [frel_exp(:) ...
     freal_exp(:) ...
     lambda_exp(:) ...
     amp_exp(:)];

[fileOut,pathOut] = uiputfile('*.xlsx',...
    'Guardar espectro Fourier',...
    'Espectro_Fourier_Completo.xlsx');

if ~isequal(fileOut,0)

    encabezado = { ...
        'Frecuencia_relativa',...
        'Frecuencia_real_ciclos_m',...
        'Longitud_onda_m',...
        'Amplitud'};

    writecell(encabezado,...
        fullfile(pathOut,fileOut),...
        'Range','A1');

    writematrix(M,...
        fullfile(pathOut,fileOut),...
        'Range','A2');

end

fprintf('\n');
fprintf('Frecuencias exportadas: %d\n',length(frel_exp));

drawnow

pause(5)

disp('FIN')