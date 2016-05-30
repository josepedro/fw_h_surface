% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Esta fun��o calcula a press�o ac�stica P em campo distante atrav�s da
% superf�cie bi-dimenssional de Fowcs-Williams e Hawkings, proposta por 
% Parametros a definir Lockard (2000). Os dados de entrada s�o os
% segu8intes:
%
% P = fwh(MM,f,U,V,pesc)
%
% MM � a matriz obtida atrav�s da simula��o computacional com os dados de
% press�o total p, velocidade total ux e uy capturados na superf�cie para
% cada timestep. A matriz MM possui as seguintes dimens�es:
% [n_pontos,n_timesteps,3]. As linhas s�o os resultados obtidos para cada
% ponto na superf�cie para um �nico timestep. As duas primeiras colunas s�o
% as coordenadas de cada ponto da superf�cie (x e y). As demais colunas s�o
% os resultados obtidos na superf�cie para cada timestep. A primeira folha
% da matriz apresenta a press�o total p. As folhas subsequentes s�o as
% velocidades totais ux e uy, respectivamente.
%
% f � a frequencia de an�lise em unidade de lattice (varia de 0 a 0.5)
% U � velocidade m�dia do escoamento em x              
% V � velocidade m�dia do escoamento em y                 
% pesc � ponto de escuta em unidade de lattice (deve ser um vetos do tipo
% [coord_x coord_y]
%
% Andry R. da Silva. UFSC 2016
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function P = fwh(MM,f,U,V,pesc)


%% Aqui � onde tudo come�a

% Propriedades do escoamento


omega = 2*pi*f; % frequ em rad/sec em lattice
k = omega*sqrt(3); % numero de onda


theta = atan(V/U);
M = sqrt(U^2+V^2)*sqrt(3);
beta = sqrt(1-M^2);


x_ = (pesc(1)-MM(:,1,1))*cos(theta) + (pesc(2)-MM(:,2,1))*sin(theta);
y_ = -(pesc(1)-MM(:,1,1))*sin(theta) + (pesc(2)-MM(:,2,1))*cos(theta);

% calculando a funcao de Hankel de segundo tipo e ordem 0
argu = (k/(beta^2))*sqrt(x_.^2+beta^2*y_.^2);
H = besselj(0,argu)-i*bessely(0,argu);

% Calculando a fun��o de Green

G = (i/(4*beta))*exp(i*M*k*x_/(beta^2)).*H;

%% Calculo dos termos monopolo e dipolo

% termo monopolo e F1 e F2
tam = size(MM);
rho_0 = 1;

for col = 3:tam(2)
 
u1 = MM(1:tam(1)-1,col,2);
u2 = MM(1:tam(1)-1,col,3);
p = MM(1:tam(1)-1,col,1);
ro = p*3;
difx = diff(MM(:,1,1));
dify = diff(MM(:,2,1));

% termo monopolo
Q(:,col-2) = (ro.*u1 - rho_0*U).*difx + (ro.*u2 - rho_0*V).*dify;


% termos dipolo
F1(:,col-2) = (p+ro.*(u1-2*U).*u1+rho_0*U^2).*difx + ...
    (ro.*(u1-2*U).*u2 +rho_0*U*V).*dify;

F2(:,col-2) = (ro.*(u2-2*V).*u1 + rho_0*V*U).*difx + ...
    (p+ro.*(u2-2*V).*u2 + rho_0*V^2).*dify;

end

% Fazendo a transformada de fourier de Q e Fs

Q = fft(Q')';
F1 = fft(F1')';
F2 = fft(F2')';


freq = linspace(0,1,tam(2)-1);
[c index] = min(abs(freq-f));
% Calculando as integrais

dGdx = diff(G)./(diff(MM(:,1,1))+eps);
dGdy = diff(G)./(diff(MM(:,2,1))+eps);

P = -sum(F1(:,index).*dGdx) - sum(F2(:,index).*dGdy) - sum(i*omega*Q(:,index).*G(1:length(G)-1));





