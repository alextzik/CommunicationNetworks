%Code for the Simulation Assignment of the Course [TH0501]
%Alexandros Tzikas - AEM 8978
%alextzik@ece.auth.gr
%Note: The code was implemented in MATLAB R2014b

E_A=20;
E_B=200;

syms k
%---------ii----------------------------
r=E_B/E_A;
%Analytic Solution
N_maxBlockage=1;
probBlockage=double((r^N_maxBlockage/factorial(N_maxBlockage))/ subs(symsum(r^k/factorial(k), k, 0, N_maxBlockage)));
while(probBlockage>0.2)
    N_maxBlockage=N_maxBlockage+1;
    probBlockage=double((r^N_maxBlockage/factorial(N_maxBlockage))/ subs(symsum(r^k/factorial(k), k, 0, N_maxBlockage)));
end
N_maxBlockage=N_maxBlockage-1;

N_minBlockage=1;
probBlockage=double((r^N_minBlockage/factorial(N_minBlockage))/ subs(symsum(r^k/factorial(k), k, 0, N_minBlockage)));
while(probBlockage>0.001)
    N_minBlockage=N_minBlockage+1;
    probBlockage=double((r^N_minBlockage/factorial(N_minBlockage))/ subs(symsum(r^k/factorial(k), k, 0, N_minBlockage)));
end
%Plot Analytic Solution
NsAnalytic=N_maxBlockage:1:N_minBlockage;
probBlockageAnalytic=zeros(1, length(NsAnalytic));
i=1;
for n=N_maxBlockage:1:N_minBlockage
    probBlockageAnalytic(i)=double((r^n/factorial(n))/ subs(symsum(r^k/factorial(k), k, 0, n)));
    i=i+1;
end

figure(1);
plot(NsAnalytic, probBlockageAnalytic, 'o');
xlabel('\fontname{Bookman Old Style} Number of Service Positions');
ylabel('\fontname{Bookman Old Style} Probability of Blockage');
title('\fontname{Bookman Old Style} Probability of Blockage as a function of the Number of Service Positions');

%Simulation

probBlockageSim=zeros(1,length(N_maxBlockage:1:N_minBlockage));
j=1;
for n=N_maxBlockage:1:N_minBlockage
    servicePos=zeros(1,n); %Array containing the remaining time that each service position is occupied.
    i=0;
    interarrival=0;
    blockedPackages=0;
    while(i<10^5)
        if(interarrival==0)
            callDuration=exprnd(E_B);
            indexOfPos=find(servicePos<=0, 1);
            if(isempty(indexOfPos))
                blockedPackages=blockedPackages+1; 
            else
                servicePos(indexOfPos)=callDuration;
            end
            i=i+1;
            interarrival=exprnd(E_A);
        end
    
        servicePos=servicePos-interarrival;
        interarrival=0; 
    end

    probBlockageSim(j)=blockedPackages/10^5;
    j=j+1;
end

hold on;
plot(NsAnalytic, probBlockageSim, '*');
%%
%--------------------iii-------------------
%Simulation

probBlockageSimGaussian=zeros(1,length(N_maxBlockage:1:N_minBlockage));
j=1;
for n=N_maxBlockage:1:N_minBlockage
    servicePos=zeros(1,n); %Array containing the remaining time that each service position is occupied.
    i=0;
    interarrival=0;
    blockedPackages=0;
    while(i<10^5)
        if(interarrival==0)
            callDuration=normrnd(E_B, 1);
            indexOfPos=find(servicePos<=0, 1);
            if(isempty(indexOfPos))
                blockedPackages=blockedPackages+1; 
            else
                servicePos(indexOfPos)=callDuration;
            end
            i=i+1;
            interarrival=exprnd(E_A);
        end
    
        servicePos=servicePos-interarrival;
        interarrival=0; 
    end

    probBlockageSimGaussian(j)=blockedPackages/10^5;
    j=j+1;
end

hold on;
plot(NsAnalytic, probBlockageSimGaussian, '^');
legend('\fontsize{13} \fontname{Bookman Old Style} Theoretical (Exponential Distribution for (B))', '\fontname{Bookman Old Style} \fontsize{13} Simulated (Exponential Distribution for (B))', '\fontname{Bookman Old Style} \fontsize{13} Simulated (Gaussian Distribution for (B))');

