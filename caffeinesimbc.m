function [out1,out2,out3] = caffeinesimbc(q0, D0,kA,kcl, V) 

p.q = q0; % 
p.V = V; % mL
p.kc = kcl;
p.ka = kA;

% Initial conditions

y0 = [0 0 D0];

%% CALL SOLVER
DrugIn = [];
T1 = [];
Y1 = [];
options = odeset('MaxStep',5e-2, 'AbsTol', 1e-5,'RelTol', 1e-5,'InitialStep', 1e-2);
[Ttemp,Ytemp] = ode45(@Caffeine_eqns,[0 0.5],y0,options,p);
drugintemp = zeros(size(Ytemp(:,1)));
T1 = [T1; Ttemp];
Y1 = [Y1; Ytemp];
DrugIn = [DrugIn; drugintemp];

y0new = Ytemp(end,:);
y0new(3) = y0new(3) + D0;
[Ttemp,Ytemp] = ode45(@Caffeine_eqns,[0.5 13],y0new,options,p);
drugintemp = D0*ones(size(Ytemp(:,1)));

T1 = [T1; Ttemp];
Y1 = [Y1; Ytemp];
DrugIn = [DrugIn; drugintemp];

CurrentDrug(:,1) = Y1(:,1)*p.V;
CurrentDrug(:,2) = Y1(:,2);
CurrentDrug(:,3) = Y1(:,3);
InitialDrug = D0 ;


DrugOut = CurrentDrug(:,2) ; % cumulative drug eliminated from system
BalanceD = DrugIn - DrugOut - CurrentDrug(:,1) - CurrentDrug(:,3) + InitialDrug ; %(zero = balance)

% Add an automated check/report on mass balance, since we don't want to 
% look at hundreds of mass balance graphs
% if mean(BalanceD)>1e-6
%     disp('Mass imbalance possible: ');
%     disp(BalanceD);
% end

% calculate AUC by integrating the concentration curve (trapezoidal rule)
% AUC = 0;
% for i=1:(length(Y1)-1)
%     AUC = AUC + 0.5*(Y1(i,1)+Y1(i+1,1))*(T1(i+1)-T1(i));
% end
AUC=trapz(T1,Y1(:,1));
%% RETURN OUTPUTS

out1 = AUC;
out2 = T1;
out3 = Y1(:,1);
% disp(BalanceD(end) < 1e-6)
end