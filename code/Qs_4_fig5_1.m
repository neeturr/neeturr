clc;clear all;close all;

N=500000;C=52;  % Initializing episodes and cards
s=260;         % No.of states using 12,13 and 2
totrew=zeros(s,1);
totst=zeros(s,1);
for i=1:N
    d=randperm(C);state=[]; % randomly choosing cards
    pl=d(1:2);d=d(3:end);   % selecting first 2 cards for the player
    dl=d(1:2);d=d(3:end);   % selecting next two cards for the dealer
    valued=mod(dl-1,13)+1;vald=min(valued,10);smd=sum(vald);cd=d(1); % Calculating the value of cards
    valuep=mod(pl-1,13)+1;valp=min(valuep,10);smp=sum(valp); % Calculating values for player                                              card=d(1);
     if(any(valuep==1)) && (smp<=11)   % checking for usable ace for player
        smp=smp+10;
        acep=1;else
        acep=0;
    end
    cd1=mod(cd-1,13)+1;state(1,:)=[smp,cd1,acep];  % storing the first state
       if(any(valued==1)&& (smd<=11))  % checking for usable ace for the dealer
        smd=smd+10;
        aced=1;else
        aced=0;
    end
    valuep=mod(pl-1,13)+1;valp=min(valuep,10);smp=sum(valp); % Repeatition of the game ( calculating values)                                          card=d(1);
    if(any(valued==1)) && (smd<=11) % checking for usable ace
        smd=smd+10;
        aced=1;else
        aced=0;
    end
    if(any(valuep==1)) && (smp<=11)
        smp=smp+10;
        acep=1;else
        acep=0;
    end
    while(smp<20)  % playing until the value 20 0r 21 comes
        pl=[pl,d(1)];d=d(2:end);  % hit until 20 or 21
    valuep=mod(pl-1,13)+1;valp=min(valuep,10);smp=sum(valp);
    if(any(valuep==1)) && (smp<=11)   % checking usable ace
        smp=smp+10;
        acep=1;else
        acep=0;
    end
    state(end+1,:)=[smp,cd1,acep];  % storing in the last state for the player
    valuep=mod(pl-1,13)+1;valp=min(valuep,10);smp=sum(valp);                                               card=d(1);
    if(any(valued==1)) && (smd<=11) % checking ace for dealer
        smd=smd+10;
        aced=1;else
        aced=0;
    end
    if(any(valuep==1)) && (smp<=11)
        smp=smp+10;
        acep=1;else
        acep=0;
    end
    end
    
while(smd<17)   % playing until value of card is of 17 for dealer 
    dl=[dl,d(1)];d=d(2:end); % hit until this 
    valued=mod(dl-1,13)+1;vald=min(valued,10);smd=sum(vald); % updating values
    if(any(valued==1)) && (smd<=11) % checking for usable ace
        smd=smd+10;
        aced=1;else
        aced=0;
    end
end
%%%%%%%%%%%%    Determining rewards%%%%%%%%%%%%%%
if(smp>21)       
    reward=-1;end 
if(smp==smd)
    reward=0; end 
if(smp>smd)
    reward=1;
else reward=-1; end
if(smd>21)
    reward=1; end 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for j=1:size(state,1)   %storing values for each states
    if((state(j,1)<=21)&&(state(j,1)>=12))
        n=sub2ind([10,13,2],state(j,1)-12+1,state(j,2),state(j,3)+1);
        totrew(n)=totrew(n)+reward;  % storing the total rewards
        totst(n)=totst(n)+1;         % total states
    end
end
end

valuefun=totrew./totst;  % calculating value function
valuefun =reshape(valuefun,[10,13,2]); % reshaping for the axis bound
figure; mesh(1:13,12:21,valuefun(:,:,1));  % No usable ace
figure; mesh(1:13,12:21,valuefun(:,:,2));  % Usable ace
    
    
    
    
    