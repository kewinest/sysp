function dydt = Caffeine_eqns(t,y,p)

q=p.q;  % weight dependant
kc=p.kc; % age dependant
V=p.V;
ka=p.ka; 
dydt = zeros(3,1);    % make it a column vector

% 1 = caffeine in body (mg/L); 
% 2 = caffeine in degr (mg); 
% 3 = caffeine in gut (mg)

 dydt(1) = q/V + ka*y(3)/V - kc*y(1);
 dydt(2) =                   kc*y(1)*V;
 dydt(3) =     - ka*y(3);
