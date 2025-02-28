function [out1,out2,out3] = caffeinesimef(D1, D2, D3, kA,kcl, V) 
% returns three outputs; receives four parameters. These can be modified as
% needed to return more/fewer outputs or receive more/fewer parameters. As 
% a general rule, pass the parameters/variables you think you will need,
% rather than passing everything.

% Acetaminophen - simulation code, for setting up the parameter values and
% calling the ode solver

%% PARAMETER VALUES
% note some of these values are passed in from the driver
% it's actually unnecessary to change the names (e.g. q = q0), you could
% just use the names above. The only reason I do it here is to emphasize
% where they come from, and to leave it flexible and easy to change which
% parameters get passed.

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
[Ttemp,Ytemp] = ode45(@Caffeine_eqns,[0 1.5],y0,options,p);
drugintemp = zeros(size(Ytemp(:,1)));
T1 = [T1; Ttemp];
Y1 = [Y1; Ytemp];
DrugIn = [DrugIn; drugintemp];

y0new = Ytemp(end,:);
y0new(3) = y0new(3) + 50;
[Ttemp,Ytemp] = ode45(@Caffeine_eqns,[1.5 2.0],y0new,options,p);
drugintemp = 50*ones(size(Ytemp(:,1)));
T1 = [T1; Ttemp];
Y1 = [Y1; Ytemp];
DrugIn = [DrugIn; drugintemp];

y0new = Ytemp(end,:);
y0new(3) = y0new(3) + 50;
[Ttemp,Ytemp] = ode45(@Caffeine_eqns,[2 14.5],y0new,options,p);
drugintemp = 100*ones(size(Ytemp(:,1)));
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
AUC = 0;
for i=1:(length(Y1)-1)
    AUC = AUC + 0.5*(Y1(i,1)+Y1(i+1,1))*(T1(i+1)-T1(i));
end

%% RETURN OUTPUTS

out1 = AUC;
out2 = T1;
out3 = Y1(:,1);

end