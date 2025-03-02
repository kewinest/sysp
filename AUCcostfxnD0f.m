function AUCcostout = AUCcostfxnD0f(x1, texp,yexp)

q0 = 0;
Dexp = 80; 
kA = x1(3); 
kcL = x1(1);
V = x1(2);

[auc,t,y] = caffeinesimef(q0, Dexp,x1(3),x1(1), x1(2));

        %texp = [0.5,1,2,4,8];
        %yexp = [10,18,18,12,4];

        for j=1:length(texp)
            teval = abs(t-texp(j));
            [tmin tindex] = min(teval);
            AUCcostout(j) = y(tindex) - yexp(j);
        end

end

