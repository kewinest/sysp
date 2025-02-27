close all;
clear all;

%q1a
ka = log(2)/(7/60);
kcl = log(2)/((7+3)/2);
q0 = 0; % ug/hr
Vd = 0.6;
Dexp = 50;

weight = [110,125,135,172,231,262]*0.4536;
V = Vd*weight;

texp = [15/60, 45/60, 2, 4, 7];

yexp= [
    3.0, 4.2, 3.8, 2.8, 1.7;
    2.6, 3.7, 3.1, 2.0, 1.0;
    2.1, 3.0, 3.0, 2.5, 2.0;
    2.1, 3.0, 2.6, 2.0, 1.2;
    3.3, 4.7, 4.1, 3.1, 2.0;
    2.2, 3.2, 3.0, 2.4, 1.7;
];




% [AUC1,T1,Y11] = caffeinesimbc(q0, Dexp,5.941,0.139, 29.9);
% 
% fig1 = figure;
% ax1 = nexttile;
% plot(ax1, T1, Y11, 'k')
% title(ax1, 'Concentration of free Drug in Blood')
% ylabel(ax1, 'mg/L')
% xlabel(ax1, 'time (hrs)')
% lgd.Location = 'northeast';




% Display optimized parameters


%%
% 1b
optparams=[];
for i =1:6
    yexpopt = yexp(i,:);
    guess = [kcl V(i)];
    options = optimoptions('lsqnonlin','Display','none');
    [x_opt, resnorm] = lsqnonlin(@(x1) AUCcostfxnD0b(x1, texp, yexpopt), guess, 0, 100, options);
    optparams=[optparams;x_opt];  
    resnorm
end


kcls = optparams(:,1)
Vs = optparams(:,2)
Vds = [];
for i = 1:6
    Vds = [Vds; Vs(i,1)/weight(i)];
end
Vds
%%
%1c---------------------------------------------------------
optparams2=[];
for i =1:6
    yexpopt = yexp(i,:);
    guess = [kcl, V(i), ka];
    options = optimoptions('lsqnonlin','Display','none','Algorithm','levenberg-marquardt');
    [x_opt, resnorm] = lsqnonlin(@(x1) AUCcostfxnD0c(x1, texp, yexpopt), guess, [], [], options);
    optparams2=[optparams2;x_opt];  
end


kcls = optparams2(:,1)
Vs = optparams2(:,2)
Vds = [];
for i = 1:6
    Vds = [Vds; Vs(i,1)/weight(i)];
end
Vds
kas = optparams2(:,3)


%%
%1e
Dexp = 80;
optparams3=[];
for i =1:6
    yexpopt = yexp(i,:);
    guess = [kcl, V(i)];
    options = optimoptions('lsqnonlin','Display','none','Algorithm','levenberg-marquardt');
    [x_opt, resnorm] = lsqnonlin(@(x1) AUCcostfxnD0e(x1, texp, yexpopt), guess, [], [], options);
    optparams3=[optparams3;x_opt];  
end


kcls = optparams3(:,1)
Vs = optparams3(:,2)
Vds = [];
for i = 1:6
    Vds = [Vds; Vs(i,1)/weight(i)];
end
Vds

%%
%f
optparams4=[];
for i =1:6
    yexpopt = yexp(i,:);
    guess = [kcl, V(i), ka];
    options = optimoptions('lsqnonlin','Display','none','Algorithm','levenberg-marquardt');
    [x_opt, resnorm] = lsqnonlin(@(x1) AUCcostfxnD0f(x1, texp, yexpopt), guess, [], [], options);
    optparams4=[optparams4;x_opt];  
end


kcls = optparams4(:,1)
Vs = optparams4(:,2)
Vds = [];
for i = 1:6
    Vds = [Vds; Vs(i,1)/weight(i)];
end
Vds
kas = optparams4(:,3)



%%
%b


delayconc = [0;0]
delaytime = [0;1.5]
for i = 1:6
    [aucb,tb,yb] = caffeinesimbc(q0, Dexp,ka,optparams(i,1), optparams(i,2));
    FILE_NAME = sprintf('problemb_subject%d', i);
    tb = tb+1.5;
    tb = [delaytime;tb];
    yb = [delayconc;yb];
    writematrix([tb, yb(:,1)], FILE_NAME)
end

for i = 1:6
    [aucc,tc,yc] = caffeinesimbc(q0, Dexp,optparams2(i,3),optparams2(i,1), optparams2(i,2));
    FILE_NAME = sprintf('problemc_subject%d', i);
    tc = tc+1.5;
    tc = [delaytime;tc];
    yc = [delayconc;yc];
    writematrix([tc, yc(:,1)], FILE_NAME)
end

for i = 1:6
    [auce,te,ye] = caffeinesimef(q0, Dexp,ka,optparams3(i,1), optparams3(i,2));
    FILE_NAME = sprintf('probleme_subject%d', i);
    writematrix([te, ye(:,1)], FILE_NAME)
end

for i = 1:6
    [aucf,tf,yf] = caffeinesimef(q0, Dexp,optparams4(i,3),optparams4(i,1), optparams4(i,2));
    FILE_NAME = sprintf('problemf_subject%d', i);
    writematrix([tf, yf(:,1)], FILE_NAME)
end
 
%%
i=1
[aucb,tb,yb] = caffeinesimbc(q0, Dexp,ka,optparams(i,1), optparams(i,2));
tb = [delaytime;tb+1.5];
yb = [delayconc;yb];
figure;
plot(tb, yb,'b-', 'LineWidth', 2)   
hold on
scatter(texp+1.5, yexp(1,:));
figure;
plot(tb, yb - yexp(1,:), 'ro');
title('Residuals (Model - Data)');
xlabel('Time (hrs)');
ylabel('Residual (mg/L)'); 