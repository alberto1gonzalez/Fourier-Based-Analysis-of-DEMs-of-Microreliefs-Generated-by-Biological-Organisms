%% ===============================================================
%% Autor/(Author): Alberto González Díez
%% 
%% ES/ (EN)
%% Título/ (Title):
%% segundo_A_analisis_relieve_frecuencia_MODoct26.m
%% ES:
%% Debe ejecutarse después de:
%% Sedundo_FOSIL_eXTRAER_LAS_FRECUENCIAS_DE_FILAS_DE_UN_DEM3MODoct26.m
%%
%% OBJETIVO /(Objective)
%% ES:
%% Analizar conjuntamente la distribución espectral y la distribución
%% altimétrica del DEM para facilitar la interpretación geomorfológica
%% de las frecuencias dominantes identificadas en el análisis FFT 1D.
%% EN:
%% Joint analysis of spectral and elevation distributions in order
%% to improve the geomorphological interpretation of dominant
%% frequencies identified through the 1D FFT analysis.
%%
%% Utiliza directamente: (USES DIRECTLY)
%%      DEM
%%      f_rel
%%      f_real
%%      cFimacent2
%% EN:
%% Must be run after:
%%
%% Sedundo_FOSIL_eXTRAER_LAS_FRECUENCIAS_DE_FILAS_DE_UN_DEM3MODoct26.m
%%
%% Uses the following directly:
%%      Z
%%      f_rel
%%      f_real
%%      lambda
%%      cFimacent2

%% ===============================================================

clearvars -except DEM f_rel f_real lambda cFimacent2
if exist('DEM','var')~=1
    error('Debe ejecutarse previamente Sedundo_FOSIL_eXTRAER_LAS_FRECUENCIAS_DE_FILAS_DE_UN_DEM3MODoct26.m');
end

%% ===============================================================
%% MENU DE VISUALIZACION (DISPLAY MENU)
%% ===============================================================

disp(' ');
disp('==============================================');
disp('ANALISIS RELIEVE - FRECUENCIA');
disp('==============================================');
disp('1 -> Espectro completo');
disp('2 -> Macrorelieve');
disp('3 -> Mesorelieve');
disp('4 -> Microrelieve');
disp('==============================================');

opcion = input('Seleccione opcion: ');

switch opcion

    case 1
        xmin = 0;
        xmax = max(f_rel);

    case 2
        xmin = 0;
        xmax = 500;

    case 3
        xmin = 0;
        xmax = 100;

    case 4
        xmin = 0;
        xmax = 20;

    otherwise

        xmin = 0;
        xmax = 100;
end

%% ===============================================================
%% FIGURA 12 REVISADA
%% ===============================================================

figure(12)
clf

ax1 = axes;

plot(f_rel,cFimacent2,...
    'k',...
    'LineWidth',1.2)

grid on

xlabel('Frecuencia relativa')

ylabel('Amplitud espectral')

title('Distribucion espectral del relieve')

xlim([xmin xmax])

%% ---------------------------------------------------
%% EJE SUPERIOR (UPPER AXIS)
%% ---------------------------------------------------

ax2 = axes;

ax2.Position = ax1.Position;

ax2.Color = 'none';

ax2.XAxisLocation = 'top';

ax2.YAxis.Visible = 'off';

ax2.XLim = ax1.XLim;

ticks_rel = ax1.XTick;

ticks_real = ticks_rel .* (max(f_real)/max(f_rel));

ax2.XTick = ticks_rel;

ax2.XTickLabel = string(round(ticks_real,3));

xlabel(ax2,'Frecuencia espacial real (ciclos/m)')

%% ===============================================================
%% INFORMACION NUMERICA (NUMERICAL INFORMATION)
%% ===============================================================

freal_max = xmax*(max(f_real)/max(f_rel));

fprintf('\n');
fprintf('=======================================\n');
fprintf('ANALISIS ESPECTRAL\n');
fprintf('=======================================\n');
fprintf('Frecuencia relativa maxima : %.3f\n',xmax);
fprintf('Frecuencia real maxima     : %.3f ciclos/m\n',freal_max);

if freal_max > 0
    fprintf('Longitud de onda minima    : %.5f m\n',...
        1/freal_max);
end

fprintf('=======================================\n');

%% ===============================================================
%% FIGURA 13
%% ===============================================================

figure(13)
clf

subplot(2,1,1)

plot(f_rel,cFimacent2,...
    'k',...
    'LineWidth',1.1)

grid on

xlim([xmin xmax])

title('Distribucion espectral del relieve')

xlabel('Frecuencia relativa')

ylabel('Amplitud')


subplot(2,1,2)

histogram(DEM(:),100,...
    'FaceColor',[0.5 0.5 0.5])

grid on

title('Distribucion altimetrica del DEM')

xlabel('Elevacion (m)')

ylabel('Frecuencia')

hold on

xline(mean(DEM(:)),...
    'r',...
    'LineWidth',2)

fprintf('\n');
fprintf('Altura minima : %.6f m\n',min(DEM(:)));
fprintf('Altura maxima : %.6f m\n',max(DEM(:)));
fprintf('Altura media  : %.6f m\n',mean(DEM(:)));

disp(' ');
disp('FIGURA 12 = espectro con doble eje');
disp('FIGURA 13 = espectro + histograma altimetrico');


%% ===============================================================
%% FIGURA 14
%% ESPECTRO + HISTOGRAMA CON ESTADISTICOS
%% (SPECTRUM + HISTOGRAM WITH STATISTICS)
%% ===============================================================

figure(14)
clf

%% ---------------------------------------------------------------
%% PANEL SUPERIOR (TOP PANEL)
%% DISTRIBUCION ESPECTRAL (SPECTRAL DISTRIBUTION)
%% ---------------------------------------------------------------

subplot(2,1,1)

plot(f_rel,cFimacent2,...
    'k',...
    'LineWidth',1.2)

grid on

xlim([xmin xmax])

title('Distribucion espectral del relieve')

xlabel('Frecuencia relativa')

ylabel('Amplitud')

%% ---------------------------------------------------------------
%% PANEL INFERIOR (BOTTOM PANEL)
%% HISTOGRAMA ALTIMETRICO (ALTIMETRIC HISTOGRAM)
%% ---------------------------------------------------------------

subplot(2,1,2)

histogram(DEM(:),100,...
    'FaceColor',[0.65 0.65 0.65])

grid on

title('Distribucion altimetrica del DEM')

xlabel('Elevacion (m)')

ylabel('Frecuencia')

hold on

media_Z   = mean(DEM(:));
mediana_Z = median(DEM(:));
std_Z     = std(DEM(:));

xline(media_Z,...
      'r',...
      'LineWidth',2)

xline(mediana_Z,...
      'b',...
      'LineWidth',2)

xline(media_Z-std_Z,...
      '--r',...
      'LineWidth',1)

xline(media_Z+std_Z,...
      '--r',...
      'LineWidth',1)

legend('Histograma',...
       'Media',...
       'Mediana',...
       '\sigma inferior',...
       '\sigma superior',...
       'Location','best')



%% ---------------------------------------------------------------
%% TEXTO DE ESTADISTICOS (TEXT OF THE STATISTICS PRESENTED)
%% ---------------------------------------------------------------

texto = {
    sprintf('Min = %.5f m',min(DEM(:)))
    sprintf('Max = %.5f m',max(DEM(:)))
    sprintf('Media = %.5f m',media_Z)
    sprintf('Mediana = %.5f m',mediana_Z)
    sprintf('STD = %.5f m',std_Z)
    };

xpos = media_Z + 1.5*std_Z;

yl = ylim;

ypos = yl(2)*0.90;

text(xpos,...
     ypos,...
     texto,...
     'BackgroundColor','white',...
     'EdgeColor','black')

%% ---------------------------------------------------------------
%% SALIDA A CONSOLA (CONSOLE OUTPUT)
%% ---------------------------------------------------------------

fprintf('\n');
fprintf('==========================================\n');
fprintf('FIGURA 14\n');
fprintf('RELIEVE - FRECUENCIA - ESTADISTICOS\n');
fprintf('==========================================\n');
fprintf('Minimo   : %.6f m\n',min(DEM(:)));
fprintf('Maximo   : %.6f m\n',max(DEM(:)));
fprintf('Media    : %.6f m\n',media_Z);
fprintf('Mediana  : %.6f m\n',mediana_Z);
fprintf('STD      : %.6f m\n',std_Z);
fprintf('==========================================\n');
disp('FIN')